# solve.jl Documentation
```@meta
CurrentModule = solve
```

## `solve.SolverL`
```@docs
SolverL(type_arr,type_probs,cap_arr;infocon_bool=true,eff_bool=false)
```
This solver should be used for linear programming problems, as the GLPK optimizer used only accepts such problems. For non-linear problems (using prices), please see [`SolverNL`](@ref).

Given the type array, type distribution, and capacity array, finds the optimal allocation given the following constraints:
- Capacity: ``\Sigma_{\theta \in \Theta} f_{\theta} m_{\theta a} \leq c_a, \forall a \in A``
- Feasibility: ``\Sigma_{a \in A} m_{\theta a} \leq 1, \forall \theta \in \Theta``
- Non-negativity: `` m_{\theta a} \geq 0, \forall (\theta,a) \in \Theta \times A``
- (Incentive Compatibility, applied when `infocon_bool`==1): ``\Sigma_{a \in A} u_{\theta a} m_{\theta a} - \Sigma_{a \in A} u_{\theta a} m_{\theta' a} \geq 0, \forall \theta,\theta' \in \Theta``
- (Efficiency, applied when `eff_bool==1`): pending
Saves the following tuple when `print_bool ==1` to the folder given by `folder ==path/to/folder`: (assignment array,type array,type distribution array, incentive constraint designation). Otherwise, returns (assignment array,type array,type distribution array). Assignment array takes the form such that element `(i,j)` gives the probability that type `i` is assigned to each object `j`.

Is parametrized such that the type distribution represents unit capacity. Because prices enter the price mechanism via an incentive constraint, this solver does not support inputs for which `price_type!="none"` and `info_bool==false`.

Let us consider an example where the input is constructed using [`gen.ProblemGeneratorSimple`](@ref). 
```@repl
using DataFrames, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/gen/src/gen.jl"))
cap_df = DataFrame(cap =[.3,.7,.5]); util_df = DataFrame(mean =[10,15,20]); shock_df = DataFrame(shock=[.1,.9])
input = gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")
include(abspath("../../../../basic-program-share/src/solver/modules/solve/src/solve.jl"))
using JuMP, GLPK, MathOptInterface
const MOI = MathOptInterface
import JuMP: GenericAffExpr
a,b,c,d,f = solve.SolverL(type_arr,type_probs,cap_arr)
social_welfare = a
individual_welfare = b
assignments = c
corresponding_types = d
distribution_of_corresponding_types = f
```
Next, let's consider an example where the input is given directly.
```@repl
using DataFrames, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/solve/src/solve.jl"))
using JuMP, GLPK, MathOptInterface, Random
const MOI = MathOptInterface
import JuMP: GenericAffExpr
rng = MersenneTwister(1234);
type_arr = randn!(rng,zeros(4,2)); type_arr = broadcast(+,1,type_arr)
type_probs = randn!(rng,zeros(4,2)); type_probs = broadcast(+,1,type_probs); type_probs = broadcast(/,type_probs,sum(type_probs))
cap_arr = Array{Float64}(undef, 2); cap_arr[1] = .5; cap_arr[2] = .8
a,b,c,d,f = solve.SolverL(type_arr,type_probs,cap_arr)
social_welfare = a
individual_welfare = b
assignments = c
corresponding_types = d
distribution_of_corresponding_types = f
```
## `solve.SolverNL`
```@docs
SolverNL(type_arr,type_probs,cap_arr;infocon_bool=true,eff_bool=false,price_type="lower")
```

This solver should be used for non-linear programming problems (typically using prices), as the Ipopt optimizer used is not optimized for linear programming and will underperform the optimizer used in [`SolverL`](@ref).

Given the type array, type distribution, and capacity array, finds the optimal allocation given the following constraints:
- Capacity: ``\Sigma_{\theta \in \Theta} f_{\theta} m_{\theta a} \leq c_a, \forall a \in A``
- Feasibility: ``\Sigma_{a \in A} m_{\theta a} \leq 1, \forall \theta \in \Theta``
- Non-negativity: `` m_{\theta a} \geq 0, \forall (\theta,a) \in \Theta \times A``
- (Incentive Compatibility, applied when `infocon_bool`==1): ``\Sigma_{a \in A} u_{\theta a} m_{\theta a} - \Sigma_{a \in A} u_{\theta a} m_{\theta' a} \geq 0, \forall \theta,\theta' \in \Theta``
- (Efficiency, applied when `eff_bool==1`): pending
Saves the following tuple when `print_bool ==1` to the folder given by `folder ==path/to/folder`: (assignment array,type array,type distribution array, incentive constraint designation). Otherwise, returns (assignment array,type array,type distribution array). Assignment array takes the form such that element `(i,j)` gives the probability that type `i` is assigned to each object `j`.

Is parametrized such that the type distribution represents unit capacity. Because prices enter the price mechanism via an incentive constraint, this solver does not support inputs for which `price_type!="none"` and `info_bool==false`.

Let us consider an example of a lower-bound price-regime where the input is constructed using [`gen.ProblemGeneratorSimple`](@ref). 
```@repl
using DataFrames, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/gen/src/gen.jl"))
cap_df = DataFrame(cap =[.3,.7]); util_df = DataFrame(mean =[10,15]); shock_df = DataFrame(shock=[.1,.9])
input = gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")
include(abspath("../../../../basic-program-share/src/solver/modules/solve/src/solve.jl"))
using JuMP, GLPK, MathOptInterface, Ipopt
const MOI = MathOptInterface
import JuMP: GenericAffExpr
a,b,c,d,f,g = solve.SolverNL(input[1],input[2],input[3],price_type="lower")
social_welfare = a
indiv_welfare = b
assignments = c
corresponding_types = d
distribution_of_corresponding_types = f
prices = g
```

Now, let us consider an example of an upper-bound price-regime where the input is constructed using [`gen.ProblemGeneratorSimple`](@ref). 
```@repl
using DataFrames, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/gen/src/gen.jl"))
cap_df = DataFrame(cap =[.3,.7]); util_df = DataFrame(mean =[10,15]); shock_df = DataFrame(shock=[.1,.9])
input = gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")
include(abspath("../../../../basic-program-share/src/solver/modules/solve/src/solve.jl"))
using JuMP, GLPK, MathOptInterface, Ipopt
const MOI = MathOptInterface
import JuMP: GenericAffExpr
a,b,c,d,f,g = solve.SolverNL(input[1],input[2],input[3],price_type="upper")
social_welfare = a
indiv_welfare = b
assignments = c
corresponding_types = d
distribution_of_corresponding_types = f
prices = g
```

Finally, let us consider an example of a raffle regime where the input is constructed using [`gen.ProblemGeneratorSimple`](@ref). 
```@repl
using DataFrames, Distributions
include(abspath("../../../../basic-program-share/src/solver/modules/gen/src/gen.jl"))
cap_df = DataFrame(cap =[.3,.7]); util_df = DataFrame(mean =[10,15]); shock_df = DataFrame(shock=[.1,.9])
input = gen.ProblemGeneratorSimple(util_df,shock_df,cap_df,Logistic(),"DF")
include(abspath("../../../../basic-program-share/src/solver/modules/solve/src/solve.jl"))
using JuMP, GLPK, MathOptInterface, Ipopt
const MOI = MathOptInterface
import JuMP: GenericAffExpr
a,b,c,d,f,g = solve.SolverNL(input[1],input[2],input[3],price_type="raffle")
social_welfare = a
indiv_welfare = b
assignments = c
corresponding_types = d
distribution_of_corresponding_types = f
prices = g
```

As we can see, here the bounds are rather tight, and the proposition that the raffle regime will obtain a welfare lower than that of the optimal price regime is corroborated.
