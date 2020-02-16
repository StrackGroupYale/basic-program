push!(LOAD_PATH, "basic-program/solver")

###GENERATE CONSTRAINED ALLOCS
Main.x_t.problem_glpk("solver/2x3_example/util_data.csv",
           "solver/2x3_example/shock_data.csv",
           "logistic",
           "solver/2x3_example/cap_data.csv","solver/assignment_data",1,1)
###GENERATE UNCONSTRAINED ALLOCS
Main.x_t.problem_glpk("solver/2x3_example/util_data.csv",
           "solver/2x3_example/shock_data.csv",
           "logistic",
           "solver/2x3_example/cap_data.csv","solver/assignment_data",1,0)


###EVALUATE WELFARE
i = Main.x_t.problem_glpk("solver/2x3_example/util_data.csv",
"solver/2x3_example/shock_data.csv",
"logistic",
"solver/2x3_example/cap_data.csv","solver/assignment_data",0,1)

o = Main.x_t.welfare(i[1],i[3],i[2],i[4],0,1,1,0)
print("CONSTRAINED ",o)

i2 = Main.x_t.problem_glpk("solver/2x3_example/util_data.csv",
"solver/2x3_example/shock_data.csv",
"logistic",
"solver/2x3_example/cap_data.csv","solver/assignment_data",0,0)

o2 = Main.x_t.welfare(i2[1],i2[3],i2[2],i2[4],0,1,1,0)
print("UNCONSTRAINED ",o2)
###TIME TESTING REGIME
#Main.x_t.time_test(3,14,15,"solver/test_data/assignments")
