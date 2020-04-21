push!(LOAD_PATH,"src/solver/gen.jl")
push!(LOAD_PATH,"/Users/AnR/Dropbox/basic-profile/basic-program-share/src/solver/modules")
using Documenter, gen

makedocs(sitename="Strack Group Project Documentation")

#deploydocs(repo = "github.com/USER_NAME/PACKAGE_NAME.jl.git",)
deploydocs(repo = "github.com/STRACK_GROUP_YALE/GEN.jl.git",)
#https://USER_NAME.github.io/PACKAGE_NAME.jl/vX.Y.Z

#
#CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
#DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
#Distributions = "31c24e10-a181-5473-b8eb-7969acd0382f"
#JLD = "4138dd39-2aa7-5051-a626-17a0bb65d9c8"
#JuMP = "4076af6c-e467-56ae-b986-b466b2749572"