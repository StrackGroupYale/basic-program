push!(LOAD_PATH,abspath("../basic-program-share/src/solver/modules"))
using Documenter, gen, solve, timing, plots

makedocs(
    sitename="Strack Group Project Documentation",
    authors = "Joshua Purtell",
    modules = [gen,solve, timing, plots],
    pages = [
        "Home" => "index.md",
        "Manual" => [
            "Generating a Problem" => "man/gen.md",
            "Solving a Problem" => "man/solve.md",
            "Timing Functions" => "man/timing.md",
            "Plotting" => "man/plots.md",
        ]
    ]
)
#,format = Documenter.HTML(prettyurls=get(ENV,"CI",nothing)=="true"),