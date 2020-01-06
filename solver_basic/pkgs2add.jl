###pkg include
using Pkg
Pkg.add("CSV")
Pkg.add("Cbc")
Pkg.add("DataFrames")
Pkg.add("Distributions")
Pkg.add("MathOptInterface")
Pkg.add("JuMP")
Pkg.add("JLD")


Pkg.build("CSV")
Pkg.build("Cbc")
Pkg.build("DataFrames")
Pkg.build("Distributions")
Pkg.build("MathOptInterface")
Pkg.build("JuMP")
Pkg.build("JLD")
