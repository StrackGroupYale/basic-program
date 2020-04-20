#CPLEX_STUDIO_BINARIES= /Applications/CPLEX_Studio129/cplex/bin/x86-64_osx/ julia -e 'Pkg.add("CPLEX"); Pkg.build("CPLEX")'
#run(`export LD_LIBRARY_PATH="/Applications/CPLEX_Studio129/cplex/bin/x86-64_osx"$LD_LIBRARY_PATH`)
###pkg include
using Pkg
#using Base

#Pkg.rm("CSV")

if in("CSV",keys(Pkg.installed()))
    #println("CSV is already installed")
    #@eval using CSV
else
    println("Package is not installed")
    Pkg.add("CSV")
    Pkg.build("CSV")
end
#Pkg.add("CSV")

if in("Cbc",keys(Pkg.installed()))
    #println("Cbc is already installed")
else
    println("Package is not installed")
    Pkg.add("Cbc")
    Pkg.build("Cbc")
end

if in("DataFrames",keys(Pkg.installed()))
    #println("DataFrames is already installed")
    #@eval using DataFrames
else
    println("Package is not installed")
    Pkg.add("DataFrames")
    Pkg.build("DataFrames")
end

if in("Distributions",keys(Pkg.installed()))
    #println("Distributions is already installed")
    #@eval using Distributions
else
    println("Package is not installed")
    Pkg.add("Distributions")
    Pkg.build("Distributions")
end

if in("MathOptInterface",keys(Pkg.installed()))
    #println("Package is already installed")
    #@eval using MathOptInterface
else
    println("Package is not installed")
    Pkg.add("MathOptInterface")
    Pkg.build("MathOptInterface")
end


#Pkg.add("JuMP")

if in("JuMP",keys(Pkg.installed()))
    #println("JuMP is already installed")
    #@eval using JuMP
else
    println("JuMP is not installed")
    Pkg.add("JuMP")
    Pkg.build("JuMP")
end

#Pkg.add("JLD")

if in("JLD",keys(Pkg.installed()))
    #println("JLD is already installed")
    #@eval using JLD
else
    println("JLD is not installed")
    Pkg.add("JLD")
    Pkg.build("JLD")
end

#Pkg.add("Revise")

if in("Revise",keys(Pkg.installed()))
    #println("Revise is already installed")
    #@eval using Revise

else
    println("Revise is not installed")
    Pkg.add("Revise")
    Pkg.build("Revise")
end

#Pkg.add("GLPK")

if in("GLPK",keys(Pkg.installed()))
    #println("GLPK is already installed")
    #@eval using GLPK
else
    println("GLPK is not installed")
    Pkg.add("GLPK")
    Pkg.build("GLPK")
end

#Pkg.add("Plots")

if in("Plots",keys(Pkg.installed()))
    #println("Plots is alread installed")
    #@eval using Plots
else
    println("Plots is not installed")
    Pkg.add("Plots")
    Pkg.build("Plots")
end

#Pkg.add("CPLEX")

#if in("MathOptInterface",keys(Pkg.installed()))
    #println("Package is installed")
#    @eval using MathOptInterface
#else
#    println("Package is not installed")
#    Pkg.add("MathOptInterface")
#end

#trivial comment


#Pkg.build("CSV")
#Pkg.build("Cbc")
#Pkg.build("DataFrames")
#Pkg.build("Distributions")
#Pkg.build("MathOptInterface")
#Pkg.build("JuMP")
#Pkg.build("JLD")
#Pkg.build("Revise")
#Pkg.build("GLPK")
#Pkg.build("Plots")
#Pkg.build("CPLEX")
