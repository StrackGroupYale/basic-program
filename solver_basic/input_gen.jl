##Debugged

using Distributions
using JuMP
using CSV
using DataFrames


#Logistic Distribution Generator
function log_dist_gen(frm)
	#find number of rows
	m = size(frm,1)
	#logstic fxns
	d = Array{Float64}(undef, m)
	for i = 1:m
		mean = frm[i,1]
		scalar = frm[i,2]
		d[i]= rand(Logistic(mean,scalar)) ##create logistic function: mean, scale; then, pick a random sample
	end
	return d
end

function extract_mean(frm)
	#find number of rows
	m = size(frm,1)
	#logstic fxns
	d = Array{Float64}(undef, m)
	for i = 1:m
		mean = frm[i,1]
		scalar = frm[i,2]
		d[i]= mean ##create logistic function: mean, scale; then, pick a random sample
	end
	return d
end

function vec2df(vec)
	df = DataFrame()
	df.util_mean = vec
	return df
end


#Generate shock vector, given the length,base shock, and increment
function shock_gen_incr(shock_len,shock_base,shock_inc)
	shock = Vector{Float64}(undef, shock_len)
	for i in 1:shock_len
		shock[i] = shock_base + shock_inc*(i-1)
	end
	return shock
end



###input file gen

function data_gen(file_util,file_dist,file_cap,logi_bool,incr_bool,incr_num,incr_base,incr_incr)
#takes (CSV,CSV,CSV,2-vector,3-vector)

	#covert to dataframe
	frm_util = DataFrame(CSV.File(file_util))
	frm_dist = DataFrame(CSV.File(file_dist))
	frm_cap = DataFrame(CSV.File(file_cap))
	if (logi_bool+incr_bool>1)
		#done
		if logi_bool ==1
			util_dist = log_dist_gen(frm_util)
			shck = shock_gen_incr(incr_num,incr_base,incr_incr)
			util = Vector{Any}(undef, incr_num)
			for i in 1:incr_num
				util[i] = vec2df(broadcast(+,shck[i],util_dist))
			end
			util_dist = util
		end
		#done
		if logi_bool == 2
			shck = shock_gen_incr(incr_num,incr_base,incr_incr)
			util_dist = Vector{Any}(undef, incr_num)
			for i in 1:incr_num
				for j in 1:nrow(frm_util)
					frm_util[j,1] = frm_util[j,1] + shck[i]
				end
				util_dist[i] = vec2df(log_dist_gen(frm_util))
			end
		end
	end

	if (logi_bool+incr_bool<=1)
		#done
		if logi_bool == 1
			util_dist = vec2df(log_dist_gen(frm_util))
		end
		#done
		if incr_bool == 1
			shck = shock_gen_incr(incr_num,incr_base,incr_incr)
			util_dist = Vector{Any}(undef, incr_num)
			for i in 1:incr_num
				for j in 1:nrow(frm_util)
					frm_util[j,1] = frm_util[j,1] + shck[i]
				end
				util_dist[i] = vec2df(extract_mean(frm_util))
			end
		end
	end

	num_types = nrow(frm_util)
	num_objects = nrow(frm_cap)

	#Output file: num_types,num_objects,Util_df,Dist_df,Cap_Constraint_df
	return (num_types,num_objects,util_dist,frm_dist,frm_cap)
end
