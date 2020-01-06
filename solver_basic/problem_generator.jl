###################
#= File the creates three functions: expandgrid (credit Iain Dunning), quantile_prob_finder, data_gen.
expandgrid:
quantile_prob_finder:
data_gen:
=#
module problem_generator

export data_gen


using Distributions
using JuMP
using CSV
using DataFrames
using JLD

###input file gen

###credit to Iain Dunning
function expandgrid(args...)
    if length(args) == 0
        return Any[]
    elseif length(args) == 1
        return args[1]
    else
        rest = expandgrid(args[2:end]...)
        ret  = Any[]
        for i in args[1]
            for r in rest
                push!(ret, vcat(i,r))
            end
        end
        return ret
    end
end

function quantile_prob_finder(distribution, quant)
	d = 0.0
	if (distribution == "logistic")
		d = pdf(Logistic(),quantile(Logistic(),quant*(0.01)))
	elseif (distribution == "uniform")
		d = pdf(Uniform(),quantile(Uniform(),quant*(0.01)))
	else
		printline("Error: distribution type not supported")
	end
	return d
end

function processor(frm_util,frm_shocks,shock_distribution,frm_cap)
    num_types = nrow(frm_shocks)^nrow(frm_util) #assuming shocks given with objects in row, each vector as a column
	num_objects = nrow(frm_util)

	#convert dataframe to matrix
	util_vec = Vector{Float64}(undef, nrow(frm_util))
	for i in 1:nrow(frm_util)
		util_vec[i] = frm_util.mean[i]
	end

	shock_vec = Vector{Float64}(undef, nrow(frm_shocks))
	for i in 1:nrow(frm_shocks)
		shock_vec[i] = frm_shocks.shock[i]
	end

	cap_vec = Vector{Float64}(undef, nrow(frm_cap))
	for i in 1:nrow(frm_cap)
		cap_vec[i] = frm_cap.cap[i]
	end

	##Find all type vector permutations

	#Vector of vectors should be size nrow(frm_shocks)^nrow(frm_util)

	#create nrow(frm_util)-length array of shock vectors
	reshape_arr = Vector{Any}(undef, nrow(frm_util))
	for i in 1:nrow(frm_util)
		reshape_arr[i] = shock_vec
	end
	expanded = expandgrid(reshape_arr...)

	type_vector = reshape(expanded,(num_types,1))

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

	##generate distribution for shock vectors
	type_probs = Vector{Float64}(undef, num_types)
	for i in 1:(nrow(frm_shocks)^nrow(frm_util))
		prob = 1
		for j in 1:nrow(frm_util)
			prob = prob*quantile_probs[Int(type_vector[i][j]*100)]
		end
		type_probs[i] = prob
	end
	total2 = sum(type_probs)

	##re-normalize vector distr, given actual
	for i in 1:nrow(frm_shocks)
		type_probs[i] = type_probs[i]/total2
	end

	##generate types
	type_vec2 = Vector{Any}(undef, num_types)
	for i in 1:num_types
		type_vec2[i] = broadcast(+,util_vec,type_vector[i])
	end

	#generate type_arr
	type_arr = Array{Float64}(undef, num_types,num_objects)
	for i in 1:num_types
		for j in 1:num_objects
			type_arr[i,j] = type_vec2[i][j]
		end
	end

	d = (num_types,num_objects,type_arr,type_probs,cap_vec)
    return d
end
function data_gen(utility_means,shocks,shock_distribution,capacities) #vector, vector, string, vector

    #covert information to dataframe
    frm_util = DataFrame(CSV.File(utility_means))
    frm_shocks = DataFrame(CSV.File(shocks))
    frm_cap = DataFrame(CSV.File(capacities))
    d = processor(frm_util,frm_shocks,shock_distribution,frm_cap)
	return d
end

function data_gen_cmd()
    ##If command-line arguments are given, accept them
    #determines whether to write into file later

    utility_means = parse.(Float64,split(ARGS[2]))
    println(utility_means)
	shocks = parse.(Float64,split(ARGS[3]))
    println(shocks)
	shock_distribution = ARGS[4]
	capacities = parse.(Float64,split(ARGS[5]))
    println(capacities)
	#sixth argument is name of file to which results are written

    frm_util = DataFrame(mean = utility_means)
    frm_shocks = DataFrame(shock = shocks)
    frm_cap = DataFrame(cap =capacities)
    name = chomp(ARGS[6])
    d = processor(frm_util,frm_shocks,shock_distribution,frm_cap)
    #CSV.write("$name", DataFrame(d), writeheader=false)
    println("I'm working")
    #use JLD
    file = jldopen("$name.jld", "w")
    write(file, "d", d)
    close(file)
end

data_gen_cmd()

end #module
