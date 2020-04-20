push!(LOAD_PATH, "basic-program/solver")
include("x_t.jl")
include("gen.jl")
include("solve.jl")
#using x_t
#using solve
#using gen

###GENERATE CONSTRAINED ALLOCS
x_t.problem_glpk("solver/nt_example/util_data.csv",
           "solver/nt_example/shock_data.csv",
           "logistic",
           "solver/nt_example/cap_data.csv","solver/nt_example/assign_data",1,1,1)
###GENERATE UNCONSTRAINED ALLOCS


x_t.problem_glpk("solver/nt_example/util_data.csv",
           "solver/nt_example/shock_data.csv",
           "logistic",
           "solver/nt_example/cap_data.csv","solver/nt_example/assign_data",1,0,1)
#ARGS: paths to data, path to output

###EVALUATE WELFARE
i = x_t.problem_glpk("solver/nt_example/util_data.csv",
"solver/nt_example/shock_data.csv",
"logistic",
"solver/nt_example/cap_data.csv","solver/nt_example/assign_data",0,1)

o = x_t.welfare(i[1],i[3],i[2],i[4],"solver/nt_example/assign_data",0,1,1,0,"constrained")
#print("CONSTRAINED ",o)

i2 = x_t.problem_glpk("solver/nt_example/util_data.csv",
"solver/nt_example/shock_data.csv",
"logistic",
"solver/nt_example/cap_data.csv","solver/nt_example/assign_data",0,0)

o2 = x_t.welfare(i2[1],i2[3],i2[2],i2[4],"solver/nt_example/assign_data",0,1,1,0,"unconstrained")
#print("UNCONSTRAINED ",o2)
###TIME TESTING REGIME
#Main.x_t.time_test(3,14,15,"solver/test_data/assignments")
