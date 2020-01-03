############################
#Generalized function
############################

module problem_solver.jl

using JuMP
using Cbc

using MathOptInterface
const MOI = MathOptInterface

#Vectorization

function df2vec(df,dimlen)
	vec = Array{Float64}(undef, dimlen)
	for i in 1:dimlen
		vec[i] = df[i,1]
	end
	return vec
end

function df2arr(df,dim1len,dim2len)
	arr = Array{Float64}(undef, dim1len, dim2len)
	for i in 1:dim1len
		for j in 1:dim2len
			arr[i,j] = df[i,j]
		end
	end
	return arr
end

function mech_basic_cbc(num_types,num_objects,type_arr,type_probs,cap_vec)

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
	k = sum(assignment_arr)
	#CSV.write("/Users/joshuapurtell/Desktop/Strack_Project/assignment_data/a_data@$num_objects,$num_types.csv", DataFrame(assignment_arr), writeheader=false)
	#current directory to allow for generalization
	CSV.write("./assignment_data/a_data@$num_objects,$num_types.csv", DataFrame(assignment_arr), writeheader=false)
  return (assignment_arr)
end


#create and solve problem
function problem_cs(utility_means,shocks,shock_distribution,capacities)
	inpu = data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = mech_basic_cbc(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end


###UPDATE timing regime

function create_data(seed1,seed2,scale_factor,num_iterations)
	for i in 1:num_iterations
		println("working")
		seed1 = seed1*scale_factor^i
		seed2 = seed2*scale_factor^i
		dummy_gen(seed1,seed2)
	end
end

function time_test(seed1,seed2,scale_factor,num_iterations)
	store_arr = Array{Any}(undef, num_iterations)
	for i in 1:num_iterations
			println("I'm working!")
			seed1 = seed1*scale_factor^i
			seed2 = seed2*scale_factor^i
			#run
			d = problem_cs("~./dummy_data/util_data@$seed1,$seed2.csv",
				   	   "~./dummy_data/shock_data@$seed1,$seed2.csv",
				       "logistic",
				       "~./dummy_data/cap_data@$seed1,$seed2.csv"
				       )
			@time d
	end
end
end #module
