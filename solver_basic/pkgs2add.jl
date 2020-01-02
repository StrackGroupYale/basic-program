###pkg include
using Pkg
Pkg.add("CSV")
Pkg.add("Cbc")
Pkg.add("DataFrames")
Pkg.add("Distributions")
Pkg.add("MathOptInterface")
Pkg.add("JuMP")


Pkg.build("CSV")
Pkg.build("Cbc")
Pkg.build("DataFrames")
Pkg.build("Distributions")
Pkg.build("MathOptInterface")
Pkg.build("JuMP")

include("/Users/joshuapurtell/Desktop/Strack_Project/problem_generator.jl")
include("/Users/joshuapurtell/Desktop/Strack_Project/problem_solver.jl")
include("/Users/joshuapurtell/Desktop/Strack_Project/CSV_gen.jl")
