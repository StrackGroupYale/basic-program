push!(LOAD_PATH, "basic-program/solver_basic")
println(LOAD_PATH)

using problem_generator
using problem_solver
using CSV_gen

problem_solver.problem_cs("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")
