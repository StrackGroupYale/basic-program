push!(LOAD_PATH, "/Users/AnR/documents")
using Revise
module x_t
    export problem_glpk, direct_glpk, time_test, welfare
    using CSV
    using DataFrames
    using DelimitedFiles

    #GENERAL USE, GENERATES AND SOLVES PROBLEM
    function problem_glpk(utility_means,shocks,shock_distribution,capacities,folder ; print_bool=true,infocon_bool=true,eff_bool=false)
        inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
        outpu = Main.solve.mech_basic_glpk(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5],inpu[7],folder,inpu[6],print_bool,infocon_bool,eff_bool)
        return outpu
    end


    ###SOCIAL WELFARE CALCULATORS

    ##CALCULATE TOTAL WELFARE AND/OR INDIVIDUAL WELFARE
    #df columns initialized as x1,x2,...

    function welfare(alloc,type_prob,utility_types,type_vec_shock,folder; price_bool=false,total_bool=true,indiv_bool=true,fromCSV_bool=false,alloc_designation="constrained")
        if (fromCSV_bool == 1)
            alloc_arr = readdlm(alloc, ',', Float64)
            prob_arr = readdlm(type_prob, ',', Float64)
            ut_arr = readdlm(utility_types, ',', Float64)
        end
        if (fromCSV_bool == 0)
            alloc_arr = alloc
            prob_arr = type_prob
            ut_arr = utility_types
        end
        #println("Prob arr ",prob_arr[1])

        T = Int(length(prob_arr))
        A = Int(length(alloc)/T)

        if (total_bool == 1)
            total_df = DataFrame(Type = String[],Total = Float64[])
            for i in 1:T
                total_welfare = sum( *(prob_arr[j][1],
                                      (transpose(reshape(alloc_arr[j,:],length(alloc_arr[j,:]),1))*reshape(ut_arr[j,:],length(ut_arr[j,:]),1))[1]) for j in 1:T)
                type = type_vec_shock[i]
                type_str = "$type"
                push!(total_df, [type_str,total_welfare])
            end
        end
        if (indiv_bool == 1)
            indiv_df = DataFrame(Type = String[],Indiv = Float64[])
            for i in 1:T
                indiv_welfare = *(prob_arr[i][1],
                                      (transpose(reshape(alloc_arr[i,:],length(alloc_arr[i,:]),1))*reshape(ut_arr[i,:],length(ut_arr[i,:]),1))[1])
                type = type_vec_shock[i]
                type_str = "$type"
                push!(indiv_df, [type_str,indiv_welfare])
                #println(indiv_df)
            end
        end
        if (total_bool == indiv_bool)
            join_df = join(total_df,indiv_df, on = :Type)
        end
        if (total_bool != indiv_bool)
            if (total_bool == 1)
                join_df = total_df
            end
            if (total_bool == 0)
                join_df = indiv_df
            end
        end

        CSV.write("$folder/a_data:info$alloc_designation@$A,$T.csv", join_df)
        return join_df
    end

    ##CALCULATE CAPACITY FULFILLMENT
    function cap_count()
    end


    #TIME TESTING
    function direct_glpk(utility_max,shocks_size,folder)
        inpu = Main.gen.data_gen_direct(utility_max,shocks_size)
        outpu = Main.solve.mech_basic_glpk(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5],folder,0,1)
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
            print("done ",m)
        end
        frm_test= DataFrame(types = complexity_list,time = time_list)
        CSV.write("solver/test_data/time@$shocks_num,($uts_min,$uts_max).csv", frm_test) #, writeheader=false

        return frm_test
    end

    #ALTERNATE SOLVERS, NOT CURRENTLY SUPPORTED
    function problem_cbc(utility_means,shocks,shock_distribution,capacities)
        inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
        outpu = Main.solve.mech_basic_cbc(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
        return outpu
    end

    function problem_cplex(utility_means,shocks,shock_distribution,capacities)
        inpu = Main.gen.data_gen(utility_means,shocks,shock_distribution,capacities)
        outpu = Main.solve.mech_basic_cplex(inpu[1],inpu[2],inpu[3],inpu[4],inpu[5])
        return outpu
    end

end #module