push!(LOAD_PATH, "basic-program/solver_basic")
using problem_generator
using problem_solver

module CSV_gen
export problem_cs,create_data,time_test 
using CSV
using DataFrames

##generate Matrices:

function df_gen(num_objects,num_typevec)

    # Utility Data, M1
    # Means, 1 Dimensional (A x 1)
    u_df = DataFrame(A = Float64[])
    for i in 1:num_objects
        push!(u_df, (rand()))
    end

    # Shock Data, M2
    # Shocks Vects, 2 Dimensional (A x T)
    s_df = DataFrame()
    for i in 1:num_typevec
        new_row = Vector{Float64}(undef, num_typevec)
        new_row .= rand()
        insert!(s_df, i, new_row, :type, makeunique=true)
    end

    # Capacity Data, M3
    # 1 Dimensional, (A x 1)
    c_df = DataFrame(A = Float64[])
    for i in 1:num_objects
        push!(c_df, (rand()))
    end
    return (u_df,s_df,c_df)
end


function dummy_gen(num_objects,num_typevec)
    M = df_gen(num_objects,num_typevec)
    #Write into file
    CSV.write("dummy_data/util_data@$num_objects,$num_typevec.csv", M[1], writeheader=false)
    CSV.write("dummy_data/shock_data@$num_objects,$num_typevec.csv", M[2], writeheader=false)
    CSV.write("dummy_data/cap_data@$num_objects,$num_typevec.csv",  M[3], writeheader=false)

end

#create and solve problem
function problem_cs(utility_means,shocks,shock_distribution,capacities)
	inpu = problem_generator.data_gen(utility_means,shocks,shock_distribution,capacities)
	outpu = problem_solver.mech_basic_cbc(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
	return outpu
end


###UPDATE timing regime

function create_data(seed1,seed2,scale_factor,num_iterations)
	for i in 1:num_iterations
		println("working")
		seed1 = seed1*scale_factor^i
		seed2 = seed2*scale_factor^i
		dummy_gen(seed1,seed2)
	end
end

function time_test(seed1,seed2,scale_factor,num_iterations)
	store_arr = Array{Any}(undef, num_iterations)
	for i in 1:num_iterations
			println("I'm working!")
			seed1 = seed1*scale_factor^i
			seed2 = seed2*scale_factor^i
			#run
			d = problem_cs("basic-program/solver_basic/dummy_data/util_data@$seed1,$seed2.csv",
				   	   "basic-program/solver_basic/dummy_data/shock_data@$seed1,$seed2.csv",
				       "logistic",
				       "basic-program/solver_basic/dummy_data/cap_data@$seed1,$seed2.csv"
				       )
			@time d
	end
end

end #module
