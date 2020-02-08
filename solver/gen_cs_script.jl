push!(LOAD_PATH, "basic-program/solver_basic")
println(LOAD_PATH)

using problem_generator
using problem_solver
using exec_and_time

#uses files saved in directory where clone was saved
exec_and_time.problem_cs("util_data.csv",
           "shock_data.csv",
           "logistic",
           "cap_data.csv")
