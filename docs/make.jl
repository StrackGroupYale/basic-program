#push!(LOAD_PATH,"src/solver/gen.jl")
push!(LOAD_PATH,"/Users/AnR/Dropbox/basic-profile/basic-program-share/src/solver/modules")
using Documenter, gen, solve

makedocs(
    sitename="Strack Group Project Documentation",
    authors = "Joshua Purtell",
    modules = [gen,solve],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Gen" => "man/gen.md",
            "Solve" => "man/solve.md",
        ]
    ]
)
#,format = Documenter.HTML(prettyurls=get(ENV,"CI",nothing)=="true"),