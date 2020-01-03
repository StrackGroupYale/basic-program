module CSV_gen

export dummy_gen
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
    #CSV.write("/Users/joshuapurtell/Desktop/Strack_Project/data/util_data@$num_objects,$num_typevec.csv", M[1], writeheader=false)
    #CSV.write("/Users/joshuapurtell/Desktop/Strack_Project/data/shock_data@$num_objects,$num_typevec.csv", M[2], writeheader=false)
    #CSV.write("/Users/joshuapurtell/Desktop/Strack_Project/data/cap_data@$num_objects,$num_typevec.csv",  M[3], writeheader=false)
    
    CSV.write("~./dummy_data/util_data@$num_objects,$num_typevec.csv", M[1], writeheader=false)
    CSV.write("~./dummy_data/shock_data@$num_objects,$num_typevec.csv", M[2], writeheader=false)
    CSV.write("~./dummy_data/cap_data@$num_objects,$num_typevec.csv",  M[3], writeheader=false)

end

end #module
