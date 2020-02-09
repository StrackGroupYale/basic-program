push!(LOAD_PATH, "basic-program/solver")
println(LOAD_PATH)

using gen
using solve
using x_t

##Load results to verify concurrance
exec_and_time.problem_glpk("basic-program/solver/2x3_example/util_data.csv",
           "basic-program/solver/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver/2x3_example/cap_data.csv")
#=
exec_and_time.problem_cbc("basic-program/solver_basic/2x3_example/util_data.csv",
           "basic-program/solver_basic/2x3_example/shock_data.csv",
           "logistic",
           "basic-program/solver_basic/2x3_example/cap_data.csv")

exec_and_time.problem_cplex("basic-program/solver_basic/2x3_example/util_data.csv",
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

z = @elapsed exec_and_time.problem_cplex("basic-program/solver_basic/2x3_example/util_data.csv",
          "basic-program/solver_basic/2x3_example/shock_data.csv",
          "logistic",
          "basic-program/solver_basic/2x3_example/cap_data.csv")

#println("glpk: ",x," cbc: ",y, " cplex: ",z)
#println("IMWORKING")
=#

#cbc
#4 schools,3 shocks = 19s
#4 schools,4 shocks = 14s
#4 schools,5 shocks = 410s
#4 schools,6 shocks = 6100s

#glpk
#4 schools,3 shocks = 4.5e-8s
