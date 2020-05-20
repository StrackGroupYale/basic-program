module solve
push!(LOAD_PATH,abspath("../basic-program-share/src/solver/modules"))
export SolverGLPK, ModelSolver
using JuMP
using Cbc
using GLPK
using Ipopt
using DataFrames
using CSV
using JLD
using MathOptInterface
using gen
const MOI = MathOptInterface
import JuMP: GenericAffExpr

## This function returns the absolute value of v
## Helper function for double_or_nothing
function abs(v,m)
	aux = @variable(m)
	@constraint(m, aux >= v)
	@constraint(m, aux >= -v)
	return aux
end

## Helper function for is_pos
function double_or_nothing(v,m)
	aux2 = @variable(m)
	#if v positive, aux2 = 0. if v negative, aux2 = |2v|
	@constraint(m, aux2 >= (abs(v,m)-v-0.000000000000000000002))
	@constraint(m, aux2 <= (abs(v,m)-v+0.000000000000000000001))
	return aux2
end

##Returns 1 if v < 0, 0 if v > 0
function is_pos(v,m)
	aux3 = @variable(m)
	@constraint(m, aux3 <= 1.0)
	@constraint(m, aux3 >= -0.001)
	@constraint(m, aux3 <= abs(double_or_nothing(v,m)-2*abs(v,m),m)) 
	#aux3 = 0 if negative, aux3 = 1 if positive
	return aux3
end

function is_pos_float(v,m)
	aux3 = @variable(m)
	@constraint(m, aux3 <= 1.0)
	@constraint(m, aux3 >= -0.001)
	@constraint(m, aux3 <= abs(double_or_nothing(v,m)-2*abs(v,m),m)) 
	#aux3 = 0 if negative, aux3 = 1 if positive
	if (aux3 > .5)
		return 1.0
	end
	if (aux3 < .5)
		return 0.0
	end
end


function add_lower_con(m,X,P,type_arr,T,A)
	@NLexpression(m, my_expr[i=1:T,l=1:A], type_arr[i,l]/(P[l]+1e-7) - sum( type_arr[i,k]*X[i,k] for k in 1:A))
	@NLconstraint(m, con[i=1:T,l=1:A], my_expr[i,l] <= 0)
end
function add_upper_con(m,X,P,type_arr,T,A)
	@NLexpression(m, my_expr1[i=1:T,l=1:A], -1 + sum( type_arr[i,k]*X[i,k] for k in 1:A))
	@NLexpression(m, my_expr2[i=1:T,l=1:A], -type_arr[i,l]/(P[l]+1e-7) + sum( type_arr[i,k]*X[i,k] for k in 1:A))
	
	@NLconstraint(m, con[i=1:T,l=1:A], pos_approx(my_expr1[i,l]) + pos_approx(my_expr2[i,l]) >= .5) #min condition is decomposed as either or
end
function add_raffle_con(m,X,P,type_arr,type_probs,cap_arr,T,A)
	###both constraints
	@NLexpression(m, my_expr3[i=1:T,l=1:A], type_arr[i,l] - P[l]*sum( type_arr[i,k]*X[i,k] for k in 1:A))
	@NLconstraint(m, con[i=1:T,l=1:A], my_expr3[i,l] <= 0)

	@NLexpression(m, my_expr4[l=1:A], (P[l]-1)*(sum(type_probs[i]*X[i,l] for i in 1:T) - cap_arr[l] - 1e-4)) #(transpose(type_probs)*X)[l]
	@NLconstraint(m, con_slack[l=1:A], my_expr4[l] == 0)
end


##SOLVES PROBLEM USING GLPK SOLVER

"""
	SolverL(type_arr,type_probs,cap_arr;infocon_bool=true,eff_bool=false)

Applies ModelSolver with GLPK Optimizer. Use for Linear Programming (without prices)
"""
function SolverL(type_arr,type_probs,cap_arr;infocon_bool=true,eff_bool=false)
	m = Model(optimizer_with_attributes(GLPK.Optimizer, "tm_lim" => 60000, "msg_lev" => GLPK.OFF))
	t = ModelSolverL(type_arr,type_probs,cap_arr,m,infocon_bool,eff_bool,"none")
	return t
end

"""
	SolverNL(type_arr,type_probs,cap_arr;infocon_bool=true,eff_bool=false,price_type="lower")

Applies ModelSolver with Ipopt Optimizer. Use for Nonlinear Programming (with prices)
"""
function SolverNL(type_arr,type_probs,cap_arr;infocon_bool=true,eff_bool=false,price_type="lower")
	m = Model(optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0 ))
	t = ModelSolverNL(type_arr,type_probs,cap_arr,m,infocon_bool,eff_bool,price_type)
	return t
end


###solves given model

"""
	ModelSolverL(type_arr,type_probs,cap_arr,m,infocon_bool,eff_bool,price_type)
Given a model `m`, ModelSolver solves the optimization problem subject to the appropriate constraints.
"""
function ModelSolverL(type_arr,type_probs,cap_arr,m,infocon_bool,eff_bool,price_type)
	
	T = size(type_arr)[1] #rows, represents length of Theta
	A = size(type_arr)[2] #columns, represents length of A

	#Alloc variable
	@variable(m, X[1:T,1:A])

	#Price variable
	if price_type != "none"
		@variable(m, P[1:A])
	end

	#capacity constraint
	@constraint(m, Ccon[j = 1:A], (transpose(type_probs)*X)[j] <= cap_arr[j] - 1e-4) #enforce strictness

	#feasibility constraint
	ones_T = ones(T,1)
	ones_A = ones(A,1)
	@constraint(m, Fcon, X*ones_A .<= ones_T)

	#non-negativity constraint
	@constraint(m, ncon, X .>= 0)

	if price_type != "none"
		@constraint(m, npcon, P .>= 0) #division by zero
	end

	#Incentive Compatibility constraint
	if (infocon_bool == true && price_type == "none")
		@constraint(m, con[i=1:T,j=1:T], add_to_expression!(sum( type_arr[i,k]*X[i,k] for k in 1:A),-sum( type_arr[i,k]*X[j,k] for k in 1:A))>= 0)
	elseif (infocon_bool == false && price_type != "none")
		println("UNSUPPORTED INPUT PARAMETERS. SEE DOCUMENTATION")
	end

	##Efficiency Constraints
	if (eff_bool = true)
		
		#Ex-Post No-Trade Efficiency Constraint
		@constraint(m, nt_con[i=1:T,j=1:T,k=1:A,l=1:A],
		#if both aren't positive, dominates inequality. Enforces positivity
		-1e5*(is_pos(X[i,k],m) + is_pos(X[j,l],m)-2) 
		#check if one of the utility differences is negative
		+is_pos(type_arr[i,k]-type_arr[i,l],m) #1 if true, 0 if false
		+is_pos(type_arr[j,l]-type_arr[j,k],m) #1 if true, 0 if false
		#checks if utilities are equal
		+(1-is_pos(abs(abs(type_arr[i,k]-type_arr[i,l],m)+abs(type_arr[j,k]-type_arr[j,l],m),m)-0.00001,m)) #turns to 0 if false, 1 if true
			>= .5) #need at least one condition to hold true
		

		#Not Wasteful Constraint
		@constraint(m, nw_con[i=1:T,k=1:A,l=1:A], 
		is_pos(-X[i,k],m) #indicator for false
		+is_pos(type_arr[i,k]-type_arr[i,l],m) #indicator for false
		+is_pos(sum(type_probs[j]*X[j,l] for j in 1:T)-cap_arr[l],m) #indicator for false
		###one condition must be false
		>= .5)

	end

	#objective
	@objective(m, Max, sum(type_probs[i]*sum(X[i,k]*type_arr[i,k] for k in 1:A) for i in 1:T))
	status = optimize!(m)

	#find argmax
	assignment_arr = Array{Float64}(undef, T,A)
	for i in 1:T
		for j in 1:A
			assignment = MOI.get(m, MOI.VariablePrimal(),X[i,j])
			if (assignment < 1*10^(-10))
				assignment = 0.0
			end
			assignment_arr[i,j] = assignment
		end
	end

	if price_type != "none"
		price_arr = Array{Float64}(undef,A)
		for j in 1:A
			price = MOI.get(m, MOI.VariablePrimal(),P[j])
			if (price < 1*10^(-10))
				price = 0.0
			end
			price_arr[j] = price
		end
	end

	#find welfare
	welfare = objective_value(m)
	if (price_type != "none")
		return (welfare,assignment_arr,type_arr,type_probs,price_arr)
	else 
		return (welfare,assignment_arr,type_arr,type_probs)
	end
end

"""
	ModelSolverNL(type_arr,type_probs,cap_arr,m,infocon_bool,eff_bool,price_type)
Given a model `m`, ModelSolver solves the optimization problem subject to the appropriate constraints.
"""
function ModelSolverNL(type_arr,type_probs,cap_arr,m,infocon_bool,eff_bool,price_type)
	
	#register problems 
	pos_approx(x) = (2^(10*x)/(2^(10*x)+1))
	register(m, :pos_approx, 1, pos_approx, autodiff=true)


	T = size(type_arr)[1] #rows, represents length of Theta
	A = size(type_arr)[2] #columns, represents length of A

	#Alloc variable
	@variable(m, X[1:T,1:A])

	#Price variable
	if price_type != "none"
		@variable(m, P[1:A])
	end

	#capacity constraint
	@constraint(m, Ccon[j = 1:A], (transpose(type_probs)*X)[j] <= cap_arr[j] - 1e-4) #enforce strictness

	#feasibility constraint
	ones_T = ones(T,1)
	ones_A = ones(A,1)
	@constraint(m, Fcon, X*ones_A .<= ones_T)

	#non-negativity constraint
	@constraint(m, ncon, X .>= 0)

	if price_type != "none"
		@constraint(m, npcon, P .>= 0) #division by zero
	end

	#Incentive Compatibility constraint
	if (infocon_bool == true && price_type == "none")
		@constraint(m, con[i=1:T,j=1:T], add_to_expression!(sum( type_arr[i,k]*X[i,k] for k in 1:A),-sum( type_arr[i,k]*X[j,k] for k in 1:A))>= 0)
	elseif (infocon_bool == true && price_type == "lower")
		add_lower_con(m,X,P,type_arr,T,A)
	elseif (infocon_bool == true && price_type == "upper")
		add_upper_con(m,X,P,type_arr,T,A)
	elseif (infocon_bool == true && price_type == "raffle")
		add_raffle_con(m,X,P,type_arr,type_probs,cap_arr,T,A)
	elseif (infocon_bool == false && price_type != "none")
		println("UNSUPPORTED INPUT PARAMETERS. SEE DOCUMENTATION")
	end

	##Efficiency Constraints
	if (eff_bool = true)
		
		#Ex-Post No-Trade Efficiency Constraint
		@constraint(m, nt_con[i=1:T,j=1:T,k=1:A,l=1:A],
		#if both aren't positive, dominates inequality. Enforces positivity
		-1e5*(is_pos(X[i,k],m) + is_pos(X[j,l],m)-2) 
		#check if one of the utility differences is negative
		+is_pos(type_arr[i,k]-type_arr[i,l],m) #1 if true, 0 if false
		+is_pos(type_arr[j,l]-type_arr[j,k],m) #1 if true, 0 if false
		#checks if utilities are equal
		+(1-is_pos(abs(abs(type_arr[i,k]-type_arr[i,l],m)+abs(type_arr[j,k]-type_arr[j,l],m),m)-0.00001,m)) #turns to 0 if false, 1 if true
			>= .5) #need at least one condition to hold true
		

		#Not Wasteful Constraint
		@constraint(m, nw_con[i=1:T,k=1:A,l=1:A], 
		is_pos(-X[i,k],m) #indicator for false
		+is_pos(type_arr[i,k]-type_arr[i,l],m) #indicator for false
		+is_pos(sum(type_probs[j]*X[j,l] for j in 1:T)-cap_arr[l],m) #indicator for false
		###one condition must be false
		>= .5)

	end

	#objective
	@objective(m, Max, sum(type_probs[i]*sum(X[i,k]*type_arr[i,k] for k in 1:A) for i in 1:T))
	status = optimize!(m)

	#find argmax
	assignment_arr = Array{Float64}(undef, T,A)
	for i in 1:T
		for j in 1:A
			assignment = MOI.get(m, MOI.VariablePrimal(),X[i,j])
			if (assignment < 1*10^(-10))
				assignment = 0.0
			end
			assignment_arr[i,j] = assignment
		end
	end

	if price_type != "none"
		price_arr = Array{Float64}(undef,A)
		for j in 1:A
			price = MOI.get(m, MOI.VariablePrimal(),P[j])
			if (price < 1*10^(-10))
				price = 0.0
			end
			price_arr[j] = price
		end
	end

	#find welfare
	welfare = objective_value(m)
	if (price_type != "none")
		return (welfare,assignment_arr,type_arr,type_probs,price_arr)
	else 
		return (welfare,assignment_arr,type_arr,type_probs)
	end
end


end #module


		#@NLexpression(m, expr1[i=1:T,l=1:A], -type_arr[i,l]/(P[l]+1e-7))
		#@NLexpression(m, expr2[i=1:T,l=1:A], -sum( type_arr[i,k]*X[i,k] for k in 1:A))
		#@NLexpression(m, my_expr1[i=1:T,l=1:A], pos_approx(expr1[i,l] + expr2[i,l]))
		#@NLexpression(m, my_expr1[i=1:T,l=1:A], pos(-type_arr[i,l]/(P[l]+1e-7) - sum( type_arr[i,k]*X[i,k] for k in 1:A)))
		#@expression(m, my_expr2[i=1:T,l=1:A], is_pos(-(1 - sum( type_arr[i,k]*X[i,k] for k in 1:A)),m)) #works
		#@NLconstraint(m, con[i=1:T,l=1:A], my_expr1[i,l] + my_expr2[i,l] >= .5) #min statement decomposed as or statement
		#@NLconstraint(m, test_con[i=1:T,l=1:A], my_expr2[i,l] >= 0)
