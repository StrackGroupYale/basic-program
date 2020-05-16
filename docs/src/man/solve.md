
# solve.jl Documentation
```@meta
CurrentModule = solve
```

## `solve.SolverGLPK`
```@docs
SolverGLPK(num_types,num_objects,type_arr,type_probs,cap_arr,rtype_arr,folder,type_vec_shock,print_bool,infocon_bool,eff_bool)
```
```@repl
using DataFrames
include("/Users/AnR/Dropbox/Basic-Profile/basic-program-share/src/solver/modules/gen/src/gen.jl")
cap_df = DataFrame(cap =[.3,.7,.5]); util_df = DataFrame(mean =[10,15,20]); shock_df = DataFrame(shock=[.1,.9])
input = gen.ProblemGenerator(util_df,shock_df,cap_df,"logistic","DF")
include("/Users/AnR/Dropbox/Basic-Profile/basic-program-share/src/solver/modules/solve/src/solve.jl")
using JuMP, GLPK, MathOptInterface
const MOI = MathOptInterface
import JuMP: GenericAffExpr
output = solve.SolverGLPK(input[1],input[2],input[4],input[7],input[3],input[6],"output",input[5],0,1,0)[1]
```

## `solve.ModelSolver`
```@docs
ModelSolver(num_types,num_objects,type_arr,type_probs,cap_arr,rtype_arr,m,folder,type_vec_shock,print_bool,infocon_bool,eff_bool)
```


Given the number of types, number of means, capacity array, type arrays and type distribution, finds the optimal allocation given the following constraints:
- Capacity
- Feasibility
- Non-negativity
- (Incentive Compatibility, applied when `infocon_bool`==1)
- (Efficiency, applied when `eff_bool`==1)
Saves the following tuple when `print_bool` ==1: (assignment array,type array,type distribution array, vector of raw type vectors, incentive constraint designation). Otherwise, returns (assignment array,type array,type distribution array, vector of raw type vectors). Assignment array takes the form such that element `(i,j)` gives the probability that type `i` is assigned to each object `j`.

Is parametrized such that the type distribution represents unit capacity.