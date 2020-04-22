push!(LOAD_PATH, "basic-program/solver")

include("pkgs.jl")
include("x_t.jl")
include("gen.jl")
include("solve.jl")

###GENERATE CONSTRAINED ALLOCS
x_t.problem_glpk("solver/2x3_example/util_data.csv",
           "solver/2x3_example/shock_data.csv",
           "logistic",
           "solver/2x3_example/cap_data.csv","solver/2x3_example/assign_data",eff_bool=true)
###GENERATE UNCONSTRAINED ALLOCS


#=
x_t.problem_glpk("solver/nt_example/util_data.csv",
           "solver/nt_example/shock_data.csv",
           "logistic",
           "solver/nt_example/cap_data.csv","solver/nt_example/assign_data",infocon_bool=false)
#ARGS: paths to data, path to output

###EVALUATE WELFARE
i = x_t.problem_glpk("solver/nt_example/util_data.csv",
"solver/nt_example/shock_data.csv",
"logistic",
"solver/nt_example/cap_data.csv","solver/nt_example/assign_data",print_bool=false)

o = x_t.welfare(i[1],i[3],i[2],i[4],"solver/nt_example/assign_data")
#print("CONSTRAINED ",o)

i2 = x_t.problem_glpk("solver/nt_example/util_data.csv",
"solver/nt_example/shock_data.csv",
"logistic",
"solver/nt_example/cap_data.csv","solver/nt_example/assign_data",infocon_bool=false,print_bool=false)

o2 = x_t.welfare(i2[1],i2[3],i2[2],i2[4],"solver/nt_example/assign_data")


#### Efficiency Constrained 

###GENERATE CONSTRAINED ALLOCS
x_t.problem_glpk("solver/nt_example/util_data.csv",
           "solver/nt_example/shock_data.csv",
           "logistic",
           "solver/nt_example/cap_data.csv","solver/nt_example/assign_data",eff_bool=true)


###GENERATE UNCONSTRAINED ALLOCS
x_t.problem_glpk("solver/nt_example/util_data.csv",
           "solver/nt_example/shock_data.csv",
           "logistic",
           "solver/nt_example/cap_data.csv","solver/nt_example/assign_data",info_bool=false,eff_bool=true)
#ARGS: paths to data, path to output

###EVALUATE WELFARE
j = x_t.problem_glpk("solver/nt_example/util_data.csv",
"solver/nt_example/shock_data.csv",
"logistic",
"solver/nt_example/cap_data.csv","solver/nt_example/assign_data",print_bool=false,eff_bool=true)

p = x_t.welfare(j[1],j[3],j[2],j[4],"solver/nt_example/assign_data")
#print("CONSTRAINED ",o)

j2 = x_t.problem_glpk("solver/nt_example/util_data.csv",
"solver/nt_example/shock_data.csv",
"logistic",
"solver/nt_example/cap_data.csv","solver/nt_example/assign_data",print_bool=false,info_bool=false,eff_bool=true)

p2 = x_t.welfare(j2[1],j2[3],j2[2],j2[4],"solver/nt_example/assign_data")
=#