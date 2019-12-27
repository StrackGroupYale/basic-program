##Undebugged

using Distributions
using JuMP
using CSV
using DataFrames


#Shock Regime

function shock_gen_incr(shock_num,shock_base,shock_inc)
	shock = Vector{T}(float, n)
	for i in 1:shock_num
		shock[i] = shock_base + shock_inc*(i-1)
	end
	return shock
end

#general 
function shocks(Util,shock)
	s_Util = broadcast(+,Util,shock)
	return s_Util
end


#Logistic Distribution Generator
function log_dist_gen(frm)
	#find number of rows
	m = size(frm,1)
	#find number of columns
	n = size(frm,2)
	#logstic fxns
	d = Array{T}(undef, m, n)
	for (i in 1:n, isodd(i)==true) #only index over means
		for i in 1:m
			d[i]= Logistic(frm[i,n],frm[i,n+1]) ##create logistic function: mean, scale
		end
	end
	return d
end
		
	
#input file gen
function data_gen(file_util,file_dist,file_cap)
	print("Do you wish to input data directly (or have you invoked using a CSV file)? Y or (N)")
	if readline() == Y
		print("Please enter the following UTILITY info in CSV format: col1:means,col2:scalefactor")
		data = CSV.File(readline())
		frm_util = CSV.read(data)
		print("Please enter the following DISTANCE info in CSV format: colx:means_distfromx,colx+1:scalefactor")
		data = CSV.File(readline())
		frm_dist = CSV.read(data)
		print("Please enter the following CAPACITY info in CSV format: col1:means,col2:scalefactor")
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
	#Make Log Dists
	util_dist = log_dist_gen(frm_util)
	dist_dist = log_dist_gen(frm_dist)
	cap_dist = log_dist_gen(frm_cap)
	
	num_types = nrow(frm_util)
	num_objects = nrow(frm_cap)
	
	#Output file: num_types,num_objects,Util_df,Dist_df,Cap_Constraint_df
	return (num_types,num_objects,util_dist,dist_dist,cap_dist)
end






