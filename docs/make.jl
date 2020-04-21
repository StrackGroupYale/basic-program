push!(LOAD_PATH,"src/solver/gen.jl")
push!(LOAD_PATH,"/Users/AnR/Dropbox/basic-profile/basic-program-share/src/solver/modules")
using Documenter, gen

makedocs(sitename="Strack Group Project Documentation")

#deploydocs(repo = "github.com/USER_NAME/PACKAGE_NAME.jl.git",)
deploydocs(repo = "github.com/STRACK_GROUP_YALE/GEN.jl.git",)
#https://USER_NAME.github.io/PACKAGE_NAME.jl/vX.Y.Z

#
