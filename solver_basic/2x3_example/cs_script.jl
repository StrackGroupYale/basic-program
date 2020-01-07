push!(LOAD_PATH, "basic-program/solver_basic")
println(LOAD_PATH)

using problem_generator
using problem_solver
using exec_and_time

##Load results to verify concurrance
exec_and_time.problem_glpk("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")

exec_and_time.problem_cbc("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")

##Yield time results
x = @elapsed exec_and_time.problem_glpk("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")
y = @elapsed exec_and_time.problem_cbc("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")
println("glpk: ",x," cbc: ",y)

####For other solvers, simply write a corresponding "problem" function in "exec_and_time.jl",
####Then add correpsonding "mech_basic" functions in problem_solver.jl
####Then write the corresponding timing functions in this script
