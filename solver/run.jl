push!(LOAD_PATH, "basic-program/solver")
#println(LOAD_PATH)
#using gen
#using solve
#using x_t

#
#uses files saved in directory where clone was saved
Main.x_t.problem_glpk("solver/2x3_example/util_data.csv",
           "solver/2x3_example/shock_data.csv",
           "logistic",
           "solver/2x3_example/cap_data.csv","solver/test_data/assignments")
Main.x_t.time_test(3,10,20,"solver/test_data/assignments")
