#Debugged

###input utility value of schools, potential shocks, distribution of shocks (agent types), capacity, distances,

###output mech_basic(num_types,num_objects,type_arr,distribution_arr,capacity_vec)

using Distributions
using JuMP
using CSV
using DataFrames

###input file gen

function quantile_prob_finder(distribution, quant)
	d = 0.0
	if (distribution == "logistic")
		d = pdf(Logistic(),quantile(Logistic(),quant*(0.01)))
	elseif (distribution == "uniform")
		d = pdf(Logistic(),quantile(Uniform(),quant*(0.01)))
	else
		printline("Error: distribution type not supported")
	end
	return d
end


function data_gen(utility_means,shocks,shock_distribution,capacities)

#outputs: (num_types,num_objects,type_vec2,distribution,capacity_vec)

#utility, shock, shock distribution, variance, capacity,
#takes (CSV,CSV,CSV,2-vector,3-vector)

	#covert information to dataframe
	frm_util = DataFrame(CSV.File(utility_means))
	frm_shocks = DataFrame(CSV.File(shocks))
	frm_cap = DataFrame(CSV.File(capacities))

	num_types = ncol(frm_shocks) #assuming shocks given with objects in row, each vector as a column
	num_objects = nrow(frm_util)

	#convert dataframe to matrix
	util_arr1 = Vector{Float64}(undef, nrow(frm_util))
	for i in 1:nrow(frm_util)
		util_arr1[i] = frm_util.mean[i]
	end

	shocks_arr2 = Vector{Any}(undef, ncol(frm_shocks))
	for i in 1:ncol(frm_shocks)
		shockvec = Vector{Float64}(undef, nrow(frm_shocks))
		for j in 1:nrow(frm_shocks)
			shockvec[j]= frm_shocks[:,i][j]
		end
		shocks_arr2[i] = shockvec
	end

	cap_vec = Vector{Float64}(undef, nrow(frm_cap))
	for i in 1:nrow(frm_cap)
		cap_vec[i] = frm_cap.cap[i]
	end

	##assume independence across objects

	##find object shock probabilities, for discrete whole-number quantiles
	quantile_probs = Vector{Any}(undef, 100)
	for i in 1:100
		quantile_probs[i] = quantile_prob_finder(shock_distribution,i)
	end
	total = sum(quantile_probs)

	#normalize
	for i in 1:100
		quantile_probs[i] = quantile_probs[i]/total
	end

	##generate distribution for types/shock vectors
	type_probs = Vector{Float64}(undef, ncol(frm_shocks))
	for i in 1:ncol(frm_shocks)
		prob = 1
		for j in 1:nrow(frm_shocks)
			prob = prob*quantile_probs[Int(shocks_arr2[i][j]*100)]
		end
		type_probs[i] = prob
	end
	total2 = sum(type_probs)

	##generate total distribution
	Dist_arr = Array{Float64}(undef, nrow(frm_shocks),ncol(frm_shocks))
	for i in 1:1:ncol(frm_shocks)
		for j in 1:nrow(frm_shocks)
			Dist_arr[j,i] = quantile_probs[Int(shocks_arr2[i][j]*100)]
		end
	end

	##re-normalize vector distr, given actual
	for i in 1:ncol(frm_shocks)
		type_probs[i] = type_probs[i]/total2
	end

	##generate types
	type_vec2 = Vector{Any}(undef, ncol(frm_shocks))
	for i in 1:ncol(frm_shocks)
		type_vec2[i] = broadcast(+,util_arr1,shocks_arr2[i])
	end
	return (num_types,num_objects,type_vec2,type_probs,cap_vec,Dist_arr)
end
