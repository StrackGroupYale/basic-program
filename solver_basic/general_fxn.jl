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

##Mechanism Function
##Function Inputs: # types, # objects, utility vector, Distribution, quantity constraints
function mech_basic(num_types,num_objects,Util_vec,Dist_arr,Cap_Constraint_vec)

	T = num_types #rows, represents length of Theta
	A = num_objects #columns, represents length of A

	#Reshape utility dataset
	Util_arr = reshape(Util_vec, (T,A) )

	m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))
	
	#Alloc variable
	@variable(m, X[1:T,1:A])

	#capacity constraint
	@constraint(m, Ccon, transpose(Dist_arr)*X .<= Cap_Constraint_vec)


	#feasibility constraint
	ones_T = ones(1,T)
	ones_A = ones(1,A)

	@constraint(m, Fcon, ones_T*X .<= 1)

	#IC constraint
	@constraint(m, con[i=1:T,j=1:T], sum( Util_arr[i,k]*X[i,k] for k in 1:A)-sum( Util_arr[j,k]*X[j,k] for k in 1:A)>= 0)

	#objective
	@objective(m, Max, sum( Dist_arr[i]*(transpose(X[i,:])*Util_arr[i,:]) for i in 1:T))

	#print(m)
	status = optimize!(m)
	
  return ("info, time: ", JuMP.objective_value(m), @time JuMP.objective_value(m))
end
