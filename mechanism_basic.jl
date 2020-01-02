#####################################
# Proof of Concept Code #
#####################################

using JuMP
using Cbc

#Set M = 20
T = 3 #rows, represents length of Theta
#Set N = 10
A = 4 #columns, represents length of A

#Distribution DataSet, f_\theta
Dist_arr = Array{Float64}(undef, T,1)
for i in 1:T
    Dist_arr[i] = i^2
end

#Capacity DataSet c
Cap_arr = Array{Float64}(undef,1,A)
for j in 1:A
    Cap_arr = 1
end

#Utility DataSet
Util_arr = zeros(Float64,T,A)
for k = 1:T
    for l = 1:A
        Util_arr[k,l] = 1/(k*l)
    end
end

m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))

#Alloc variable
@variable(m, X[1:T,1:A])


#capacity constraint
@constraint(m, Ccon, transpose(Dist_arr)*X .<= Cap_arr)


#feasibility constraint
ones_T = ones(1,T)
ones_A = ones(1,A)

@constraint(m, Fcon, ones_T*X .<= 1)

#IC constraint
@constraint(m, con[i=1:T,j=1:T], sum( Util_arr[i,k]*X[i,k] for k in 1:A)-sum( Util_arr[j,k]*X[j,k] for k in 1:A)>= 0)

#objective
@objective(m, Max, sum( Dist_arr[i]*(transpose(X[i,:])*Util_arr[i,:]) for i in 1:T))


print(m)
status = optimize!(m)

println("Objective value: ", JuMP.objective_value(m))
