##Undebugged

using Distributions
using JuMP
using CSV
using DataFrames


#Logistic Distribution Generator
function log_dist_gen(frm)
	#find number of rows
	m = size(frm,1)
	#find number of columns
	n = size(frm,2)
	#logstic fxns
	d = Array{T}(undef, m, n)
	for (j in 1:n, isodd(i)==true) #only index over means
		for i in 1:m
			d[i,j]= Logistic(frm[i,j],frm[i,j+1]) ##create logistic function: mean, scale
		end
	end
	return d
end


#Generate shock vector, given the length,base shock, and increment
function shock_gen_incr(shock_len,shock_base,shock_inc)
	shock = Vector{T}(float, shock_len)
	for i in 1:shock_len
		shock[i] = shock_base + shock_inc*(i-1)
	end
	return shock
end

		
	
###input file gen

function data_gen(file_util,file_dist,file_cap)
	print("Do you wish to input data directly (or have you invoked using a CSV file)? Y or (N)")
	if readline() == Y
		print("Please enter the following UTILITY info in CSV format: col1:means,col2:scalefactor")
		data = CSV.File(readline())
		frm_util = CSV.read(data)
		print("Please enter the following DISTANCE info in CSV format: colx:means_distfromx")
		data = CSV.File(readline())
		frm_dist = CSV.read(data)
		print("Please enter the following CAPACITY info in CSV format: col1:means")
		data = CSV.File(readline())
		frm_cap = CSV.read(data)
	end
	if readline() == N
		#covert to dataframe
		frm_util = CSV.read(CSV.File(file_util))
		frm_dist = CSV.read(CSV.File(file_dist))
		frm_cap = CSV.read(CSV.File(file_cap))
	end
	else
	
	print("Do you wish to implement incremental (I) or discrete logistic (L) shocks for utility? Please enter shocks in composition order: e.g. "LI" represents incremental shocks and then logistic shocks. Enter LI,IL,I,L, or N (none)")
	if readline() == L
		util_dist = log_dist_gen(frm_util)
	end
	if readline() == LI
		util_dist = log_dist_gen(frm_util)
		print("Please enter: number of shocks, base shock, shock increment. For the shock vector -2,0,2 input 3,-2,2")
		shck = shock_gen_incr(readline())
		util = Vector{T}(undef, shock_len)
		for i in 1:shock_len
			util[i] = broadcast(+,shck[i],util_dist)
		end
		util_dist = util
	end
	if readline() == I
		print("Please enter: number of shocks, base shock, shock increment. For the shock vector -2,0,2 input 3,-2,2")
		shck = shock_gen_incr(readline())
		util = Vector{T}(undef, shock_len)
		for i in 1:shock_len
			util[i] = broadcast(+,shck[i],frm_util)
		end
		util_dist = util
	end
	if readline() == IL
		print("Please enter: number of shocks, base shock, shock increment. For the shock vector -2,0,2 input 3,-2,2")
		shck = shock_gen_incr(readline())
		util = Vector{T}(undef, shock_len)
		for i in 1:shock_len
			util[i] = broadcast(+,shck[i],frm_util)
		end
		frm_util = util
		util_dist = log_dist_gen(frm_util)
	end
	else
	
	num_types = nrow(frm_util)
	num_objects = nrow(frm_cap)
	
	#Output file: num_types,num_objects,Util_df,Dist_df,Cap_Constraint_df
	return (num_types,num_objects,util_dist,frm_dist,frm_dist)
end


####Shock Regime
