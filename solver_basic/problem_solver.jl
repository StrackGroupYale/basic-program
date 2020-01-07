############################
#Generalized function
############################

module problem_solver
export mech_basic_cbc


using JuMP
using Cbc
using DataFrames
using CSV
using JLD

using MathOptInterface
const MOI = MathOptInterface


#takes the number of types, number of objects, array of types, array of probabilities, and capacity vector and finds
#solution
function mech_basic_cbc(num_types,num_objects,type_arr,type_probs,cap_vec)
	t = processor_cbc(num_types,num_objects,type_arr,type_probs,cap_vec)
	return t
end
function mech_basic_cbc_cmd()
	d = load("$(ARGS[2]).jld")["d"]
	#println(d)
	num_types = d[1]
	num_objects = d[2]
	type_arr = d[3]
	type_probs = d[4]
	cap_vec = d[5]
	t = processor_cbc(num_types,num_objects,type_arr,type_probs,cap_vec)
	return t
end
function processor_cbc(num_types,num_objects,type_arr,type_probs,cap_vec)

	#turn cap_vec into an array
	#otherwise solver bricks, don't use 0-dim or vector

	cap_arr = Matrix{Float64}(undef,1,num_objects)
	for i in 1:num_objects
		cap_arr[i] = cap_vec[i]
	end


	T = num_types #rows, represents length of Theta
	A = num_objects #columns, represents length of A

	m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))

	#Alloc variable
	@variable(m, X[1:T,1:A])

	#capacity constraint
	@constraint(m, Ccon, transpose(type_probs)*X .<= cap_arr)

	#feasibility constraint
	ones_T = ones(1,T)
	ones_A = ones(1,A)
	@constraint(m, Fcon, ones_T*X .<= ones_A)

	#non-negativity constraint
	@constraint(m, ncon, X .>= 0)

	#Incentive Compatibility constraint
	@constraint(m, con[i=1:T,j=1:T], sum( type_arr[i,k]*X[i,k] for k in 1:A)-sum( type_arr[i,k]*X[j,k] for k in 1:A)>= 0)

	#objective
	@objective(m, Max, sum( transpose(type_probs[i])*(transpose(X[i,:])*type_arr[i,:]) for i in 1:T))

	status = optimize!(m)

	#find argmax
	assignment_arr = Array{Float64}(undef, num_types,num_objects)
	for i in 1:num_types
		for j in 1:num_objects
	 		assignment_arr[i,j] = MOI.get(m, MOI.VariablePrimal(),X[i,j])
		end
	end

	#turn assignment_arr into a dataframe

	k = sum(assignment_arr)
	#current directory to allow for generalization
	CSV.write("basic-program/solver_basic/assignment_data/a_data@$num_objects,$num_types.csv", DataFrame(assignment_arr), writeheader=false)
  return (assignment_arr)
end

if (size(ARGS)[1]>0)
    if (ARGS[1]=="cmd")
        mech_basic_cbc_cmd()
    end
end

end #module
