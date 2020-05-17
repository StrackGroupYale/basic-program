
# solve.jl Documentation
```@meta
CurrentModule = solve
```

## `solve.SolverGLPK`
```@docs
SolverGLPK(type_arr,type_probs,cap_arr,folder,print_bool,infocon_bool,eff_bool)
```
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
assignments = solve.SolverGLPK(input[1],input[2],input[3],"output",0,1,0)[1]
corresponding_types = solve.SolverGLPK(input[1],input[2],input[3],"output",0,1,0)[2]
distribution_of_corresponding_types = solve.SolverGLPK(input[1],input[2],input[3],"output",0,1,0)[3]
```
Next, let consider an example where the input is given directly.
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
assignments = solve.SolverGLPK(type_arr,type_probs,cap_arr,"output",0,1,0)[1]
corresponding_types = solve.SolverGLPK(type_arr,type_probs,cap_arr,"output",0,1,0)[2]
distribution_of_corresponding_types = solve.SolverGLPK(type_arr,type_probs,cap_arr,"output",0,1,0)[3]
```

## `solve.ModelSolver`
```@docs
ModelSolver(type_arr,type_probs,cap_arr,m,folder,print_bool,infocon_bool,eff_bool)
```


Given the number of types, number of means, capacity array, type arrays and type distribution, finds the optimal allocation given the following constraints:
- Capacity: ``\Sigma_{\theta \in \Theta} f_{\theta} m_{\theta a} \leq c_a, \forall a \in A``
- Feasibility: ``\Sigma_{a \in A} m_{\theta a} \leq 1, \forall \theta \in \Theta``
- Non-negativity: `` m_{\theta a} \geq 0, \forall (\theta,a) \in \Theta \times A``
- (Incentive Compatibility, applied when `infocon_bool`==1): ``\Sigma_{a \in A} u_{\theta a} m_{\theta a} - \Sigma_{a \in A} u_{\theta a} m_{\theta' a} \geq 0, \forall \theta,\theta' \in \Theta``
- (Efficiency, applied when `eff_bool`==1): pending
Saves the following tuple when `print_bool` ==1: (assignment array,type array,type distribution array, vector of type vectors by shock, incentive constraint designation). Otherwise, returns (assignment array,type array,type distribution array, vector of type vectors by shock). Assignment array takes the form such that element `(i,j)` gives the probability that type `i` is assigned to each object `j`.

Is parametrized such that the type distribution represents unit capacity.
