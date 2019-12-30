############################
#Generalized function
############################


#3 objects (students)
#Use discretized logistic distribution to determine type dist.
#Shock regime: 0,1,2,...,10 shocks, should multiply number of types

#Function Inputs: # types, utility vector, Distribution, # objects, quantity constraints
#Outputs: Who goes to which school / allocation
#Check w unif type vector

using JuMP
using Cbc

using MathOptInterface
const MOI = MathOptInterface

##Mechanism Function
##Function Inputs: # types # objects, type vectors, distribution, quantity constraints

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

function mech_basic_cbc(num_types,num_objects,type_vec2,type_probs,cap_vec,Dist_arr)
	#old (num_types,num_objects,Util_vec,Dist_arr,cap_vec)

	#Util_vec = df2vec(util_dist,num_types)
	#Distribution_arr = df2arr(frm_dist,num_types,num_objects)
	#cap_vec = df2vec(frm_cap,num_objects)

	#generate type_arr
	type_arr = Array{Float64}(undef, num_types,num_objects)
	for i in 1:num_types
		for j in 1:num_objects
			type_arr[i,j] = type_vec2[i][j]
		end
	end

	T = num_types #rows, represents length of Theta
	A = num_objects #columns, represents length of A

	m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))

	#Alloc variable
	@variable(m, X[1:T,1:A])

	#capacity constraint
	@constraint(m, Ccon, Dist_arr*X .<= cap_vec) #@constraint(m, Ccon, transpose(Dist_arr)*X .<= cap_vec)


	#feasibility constraint
	ones_T = ones(1,T)
	ones_A = ones(1,A)

	@constraint(m, Fcon, ones_T*X .<= 1)

	#IC constraint
	@constraint(m, con[i=1:T,j=1:T], sum( type_arr[i,k]*X[i,k] for k in 1:A)-sum( type_arr[j,k]*X[j,k] for k in 1:A)>= 0)

	#objective
	@objective(m, Max, sum( Dist_arr[i]*(transpose(X[i,:])*type_arr[i,:]) for i in 1:T))

	#print(m)
	status = optimize!(m)

	#j = MOI.get(Cbc.Optimizer, VariablePrimal(), X)

  return (status,j)
end

#fix
function compos_cbc(utility_means,shocks,shock_distribution,capacities)
	in = data_gen(utility_means,shocks,shock_distribution,capacities)
	out = mech_basic_cbc(in[1],in[2],in[3],in[4],in[5],in[6])
	return out
end
