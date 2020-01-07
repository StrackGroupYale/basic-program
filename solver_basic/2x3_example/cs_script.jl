push!(LOAD_PATH, "basic-program/solver_basic")
println(LOAD_PATH)

using problem_generator
using problem_solver
using exec_and_time

exec_and_time.problem_glpk("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")

exec_and_time.problem_cbc("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")
