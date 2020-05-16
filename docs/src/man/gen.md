# gen.jl Documentation

```@meta
CurrentModule = gen
```

## `gen.QuantileVal`
```@docs
QuantileVal(distribution, quant)
```
Takes distribution type and the quantile (i.e. 50 for 50th quantile) and returns pdf evaluated at that quantile. Is used to calculate joint probalities (we assume independence of types).
Example:

```@repl
using Distributions
include("/Users/AnR/Dropbox/Basic-Profile/basic-program-share/src/solver/modules/gen/src/gen.jl")
distribution="logistic"; quant = 40
gen.QuantileVal(distribution,quant)
```

## `gen.ProblemGenerator`
```@docs
ProblemGenerator(util,shock,cap,shock_distribution,mode)
```

Takes DataFrame inputs for utilities, shocks, capacities, and a shock distribution. Can be switched into DataFrame mode (mode="DF") and CSV mode (mode="CSV"), depending on input type.

Generates the number of types, means, the vector of capacities, the vector giving the distribution of types, and the set of types in three forms:
-  an array of types by quantile (each row is a type)
- an unnormalized array of "raw" types (mean + shock) (each row is a type)
- and a vector of types in vector form. 
`shock_distribution` currently supports only "logistic" and "uniform".

Example:

```@repl
using DataFrames
include("/Users/AnR/Dropbox/Basic-Profile/basic-program-share/src/solver/modules/gen/src/gen.jl")
cap_df = DataFrame(cap =[.7,.3]); util_df = DataFrame(mean =[15,20]); shock_df = DataFrame(shock=[.1,.5])
gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")[1:2]
gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")[3]
gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")[4]
gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")[5]
gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")[6]
gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")[7]
```
