############################
#Generalized function
############################

using JuMP
using Cbc

using MathOptInterface
const MOI = MathOptInterface

###Problem Solver###

function mech_basic_cbc(num_types,num_objects,type_vec2,type_probs,cap_vec,Dist_arr)

	##generate type_arr
	type_arr = Array{Float64}(undef, num_types,num_objects)
	for i in 1:num_types
		for j in 1:num_objects
			type_arr[i,j] = type_vec2[i][j]
		end
	end
	
	T = num_types #rows, represents length of Theta
	A = num_objects #columns, represents length of A

	##make model
	m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))

	#Alloc variable
	@variable(m, X[1:T,1:A])
	
	##Constraints
	#capacity constraint
	@constraint(m, Ccon, Dist_arr*X .<= cap_vec)

	#feasibility constraint
	ones_T = ones(1,T)
	ones_A = ones(1,A)
	@constraint(m, Fcon, ones_T*X .<= 1)

	#non-negativity constraint
	@constraint(m, ncon, X .>= 0)

	#IC constraint
	@constraint(m, con[i=1:T,j=1:T], sum( type_arr[i,k]*X[i,k] for k in 1:A)-sum( type_arr[j,k]*X[j,k] for k in 1:A)>= 0)

	##objective
	@objective(m, Max, sum( Dist_arr[i]*(transpose(X[i,:])*type_arr[i,:]) for i in 1:T))

	#print solved model
	status = optimize!(m)

	#find argmax
	assignment_arr = Array{Float64}(undef, num_types,num_objects)
	for i in 1:num_types
		for j in 1:num_objects
	 		assignment_arr[i,j] = MOI.get(m, MOI.VariablePrimal(),X[i,j])
		end
	end

  	return (assignment_arr)
end

###Compose problem generator and solver###

function compos_cbc(utility_means,shocks,shock_distribution,capacities)
	in = data_gen(utility_means,shocks,shock_distribution,capacities)
	out = mech_basic_cbc(in[1],in[2],in[3],in[4],in[5],in[6])
	return out
end
