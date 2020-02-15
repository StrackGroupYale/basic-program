#CPLEX_STUDIO_BINARIES= /Applications/CPLEX_Studio129/cplex/bin/x86-64_osx/ julia -e 'Pkg.add("CPLEX"); Pkg.build("CPLEX")'
#run(`export LD_LIBRARY_PATH="/Applications/CPLEX_Studio129/cplex/bin/x86-64_osx"$LD_LIBRARY_PATH`)
###pkg include
using Pkg
Pkg.add("CSV")
Pkg.add("Cbc")
Pkg.add("DataFrames")
Pkg.add("Distributions")
Pkg.add("MathOptInterface")
Pkg.add("JuMP")
Pkg.add("JLD")
Pkg.add("Revise")
Pkg.add("GLPK")
Pkg.add("Plots")
#Pkg.add("CPLEX")
#trivial comment


Pkg.build("CSV")
Pkg.build("Cbc")
Pkg.build("DataFrames")
Pkg.build("Distributions")
Pkg.build("MathOptInterface")
Pkg.build("JuMP")
Pkg.build("JLD")
Pkg.build("Revise")
Pkg.build("GLPK")
Pkg.build("Plots")
#Pkg.build("CPLEX")
