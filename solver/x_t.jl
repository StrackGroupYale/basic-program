push!(LOAD_PATH, "/Users/joshuapurtell/documents/github")

#using gen
#using solve
using Revise
module x_t
export problem_glpk, test_glpk, time_test#,problem_gurobi
using CSV
using DataFrames

#create and solve problem
function problem_cbc(utility_means,shocks,shock_distribution,capacities)
	inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = Main.solve.mech_basic_cbc(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end

function problem_glpk(utility_means,shocks,shock_distribution,capacities,folder)
	inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = Main.solve.mech_basic_glpk(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5],folder)
	return outpu
end

function problem_cplex(utility_means,shocks,shock_distribution,capacities)
	inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = Main.solve.mech_basic_cplex(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end

## Timing Regime
function direct_glpk(utility_max,shocks_size,folder)
	inpu = Main.gen.data_gen_direct(utility_max,shocks_size)
	outpu = Main.solve.mech_basic_glpk(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5],folder)
	return outpu
end

function time_test(shocks_num,uts_min,uts_max,folder)
    complexity_list = Float64[]
    time_list = Float64[]
    for m in uts_min:uts_max
        append!(complexity_list,shocks_num^m)
        #println(shocks_num,m)
        t = @elapsed direct_glpk(shocks_num,m,folder)
        #t = 0
        append!(time_list,t)
    end
    frm_test= DataFrame(types = complexity_list,time = time_list)
    CSV.write("solver/test_data/time@$shocks_num,$uts_max.csv", frm_test) #, writeheader=false

    return frm_test
end

end #module