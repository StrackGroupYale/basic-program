push!(LOAD_PATH, "/Users/joshuapurtell/documents/github")

#using gen
#using solve
using Revise
module x_t
export problem_cbc#,problem_gurobi
using CSV
using DataFrames

#create and solve problem
function problem_cbc(utility_means,shocks,shock_distribution,capacities)
	inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = Main.solve.mech_basic_cbc(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end

function problem_glpk(utility_means,shocks,shock_distribution,capacities)
	inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = Main.solve.mech_basic_glpk(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end

function problem_cplex(utility_means,shocks,shock_distribution,capacities)
	inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = Main.solve.mech_basic_cplex(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end
end #module

###Unsupported
#=

##generate Matrices:

function df_gen(num_objects,num_shocks)


    #Find a way to define the column names (mean, shock, cap)
    # Utility Data, M1
    # Means, 1 Dimensional (A x 1)
    println(num_objects)
    u_df = DataFrame(mean = Float64[])

    for i in 1:(num_objects+1) #counteract bug where one row is left off
        push!(u_df, (rand()))
    end
    #=
    # Shock Data, M2
    # Shocks Vects, 2 Dimensional (A x T)
    s_df = DataFrame()
    for i in 1:num_typevec
        new_row = Vector{Float64}(undef, num_typevec)
        new_row .= rand()
        insert!(s_df, i, new_row, :type, makeunique=true)
    end
    =#

    # Shock Data, M2
    # 1 Dimensional, (T x 1)
    s_df = DataFrame(shock = Float64[])
    #push!(s_df, "shock")
    for i in 1:(num_shocks+1)
        push!(s_df, (rand()))
    end

    # Capacity Data, M3
    # 1 Dimensional, (A x 1)
    c_df = DataFrame(cap = Float64[])
    #push!(c_df, "shock")
    for i in 1:(num_objects+1)
        push!(c_df, (rand()))
    end
    #normalize capacities
    #sum = sum(c_df.cap)
    #c_df.cap = broadcast(*,c_df.cap,1/sum)
    return (u_df,s_df,c_df)
end


function dummy_gen(num_objects,num_shocks)
    M = df_gen(num_objects,num_shocks)
    #Write into file
    CSV.write("basic-program/solver_basic/dummy_data/util_data@$num_objects,$num_shocks.csv", M[1], writeheader=false)
    CSV.write("basic-program/solver_basic/dummy_data/shock_data@$num_objects,$num_shocks.csv", M[2], writeheader=false)
    CSV.write("basic-program/solver_basic/dummy_data/cap_data@$num_objects,$num_shocks.csv",  M[3], writeheader=false)

end


function create_data(seed1,seed2,scale_factor,num_iterations)
	for i in 1:num_iterations
		println("working")
		seed1 = seed1*scale_factor*i
		seed2 = seed2*scale_factor*i
		dummy_gen(seed1,seed2)
	end
end

function time_test(seed1,seed2,scale_factor,num_iterations)
	store_arr = Array{Any}(undef, num_iterations)
	for i in 1:num_iterations
			println("I'm working!")
			seed1 = seed1*scale_factor*i
			seed2 = seed2*scale_factor*i
            println(seed1,seed2)
			#run
			d = problem_cs("basic-program/solver_basic/dummy_data/util_data@$seed1,$seed2.csv",
				   	   "basic-program/solver_basic/dummy_data/shock_data@$seed1,$seed2.csv",
				       "logistic",
				       "basic-program/solver_basic/dummy_data/cap_data@$seed1,$seed2.csv"
				       )
	end
end
=#
