# gen.jl Documentation

```@meta
CurrentModule = gen
```

## `gen.ProblemGeneratorSimple`
```@docs
ProblemGeneratorSimple(util,shock,cap,shock_distribution,mode)
```

Takes DataFrame inputs for utilities, shocks, capacities, and takes distributions for the shocks over each mean. Supports either a single distribution type for all inputs (e.g. `Logistic()`) or an array of distributions types of size equal to the number of means (e.g. `[Logistic(),Logistic(),Logistic()]` ). Can be switched into DataFrame mode (mode="DF") and CSV mode (mode="CSV"), depending on input type.

Returns an array of types (where entry `(i,j)` represents the value type `i` assigns to object `j`), an array of probabilities over these types (the distribution), and the capacity array.

!!! note

    `shock_distribution` currently supports only continuous distributions included in `Distributions.jl`. For example, `Logistic()` is a valid input, but `logistic` is not. Please see [this link](https://juliastats.org/Distributions.jl/stable/univariate/#Continuous-Distributions-1) for more details.

Let us consider an example where the problem specification is given as a set of DataFrames through the command line:

```@repl
using DataFrames, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/gen/src/gen.jl"))
cap_df = DataFrame(cap =[.7,.3]); util_df = DataFrame(mean =[15,20]); shock_df = DataFrame(shock=[.1,.8])
gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")[1]
gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")[2]
gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")[3]
```
Now, let us consider an example where the problem specification is given as a set of paths to the appropriate CSV files:
```@repl
using DataFrames, CSV, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/gen/src/gen.jl"))
cap_df = DataFrame(cap =[.7,.3]); util_df = DataFrame(mean =[15,20]); shock_df = DataFrame(shock=[.1,.8])
CSV.write("cap.csv", cap_df, writeheader=true);CSV.write("util.csv", util_df, writeheader=true);CSV.write("shock.csv", shock_df, writeheader=true)
gen.ProblemGeneratorSimple("util.csv","shock.csv","cap.csv",[Logistic(),Uniform()],"CSV")[1]
gen.ProblemGeneratorSimple("util.csv","shock.csv","cap.csv",[Logistic(),Uniform()],"CSV")[2]
gen.ProblemGeneratorSimple("util.csv","shock.csv","cap.csv",[Logistic(),Uniform()],"CSV")[3]
rm("util.csv");rm("shock.csv");rm("cap.csv")
```
We recommend this second method for ease of use. Please see `DataFrames.jl` for methods of converting arrays and other data types into the DataFrames type, and `CSV.jl` for saving data structures as arrays.