
module gen

export QuantileVal, ProblemGenerator


using Distributions
using JuMP
using CSV
using DataFrames
using JLD

#helper function
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

"""
	ProblemGenerator(util,shock,cap,shock_distribution,mode)
TEXT
"""
function ProblemGenerator(util,shock,cap,shock_distribution,mode)
	if mode == "CSV"
		frm_util = DataFrame(CSV.File(util))
		frm_shocks = DataFrame(CSV.File(shock))
		frm_cap = DataFrame(CSV.File(cap))
	end
	if mode == "DF"
		frm_util = util
		frm_shocks = shock
		frm_cap = cap
	end
	
	num_types = nrow(frm_shocks)^nrow(frm_util) #assuming shocks given with objects in row, each vector as a column
	num_means = nrow(frm_util)
	num_shocks = nrow(frm_shocks)

	##convert DataFrames to matrices
	util_vec = Vector{Float64}(undef, num_means)
	for i in 1:nrow(frm_util)
		util_vec[i] = frm_util.mean[i][1]
	end

	shock_vec = Vector{Float64}(undef, num_shocks)
	for i in 1:nrow(frm_shocks)
		shock_vec[i] = frm_shocks.shock[i][1]
	end

	cap_vec = Vector{Float64}(undef, num_means)
	for i in 1:nrow(frm_cap)
		cap_vec[i] = frm_cap.cap[i][1]
	end

	##Find all type vector permutations

	#Vector of vectors should be size num_types
	#create num_means-length array of shock vectors
	reshape_arr = Vector{Any}(undef, num_means)
	for i in 1:num_means
		reshape_arr[i] = shock_vec
	end
	expanded = expandgrid(reshape_arr...)
	type_vector = reshape(expanded,(num_types,1))
	type_vecprint = deepcopy(type_vector) #create a copy to print
	

	##assume independence across objects
	##find object shock probabilities, for discrete whole-number quantiles
	quantile_probs = Vector{Any}(undef, 100)
	for i in 1:100
		quantile_probs[i] = QuantileVal(shock_distribution,i)
	end
	total = sum(quantile_probs)

	#normalize
	for i in 1:100
		quantile_probs[i] = quantile_probs[i]/total
	end

	##generate distribution for shock vectors
	type_probs = Vector{Float64}(undef, num_types)
	for i in 1:(num_types)
		prob = 1
		for j in 1:num_means
			quant = Int(floor(type_vector[i][j]*100))
			if (quant == 0)
				quant = 1
			end
			prob = prob*quantile_probs[quant]
		end
		type_probs[i] = prob
	end
	total2 = sum(type_probs)

	##re-normalize vector distr, given actual
	for i in 1:(num_types)
		type_probs[i] = type_probs[i]/total2
	end

	##Print "raw" types
	rtype_arr = Array{Float64}(undef, num_types,num_means)
	for i in 1:num_types
		for j in 1:num_means
			rtype_arr[i,j] = type_vector[i][j]
		end
	end

	##generate types
	type_vec2 = Vector{Any}(undef, num_types)
	for i in 1:num_types

		#take into account the transformation
		for j in 1:num_means
			type_vector[i][j] = quantile(Logistic(),type_vector[i][j])
		end
		type_vec2[i] = broadcast(+,util_vec,type_vector[i])
	end

	#generate type_arr
	type_arr = Array{Float64}(undef, num_types,num_means)
	for i in 1:num_types
		for j in 1:num_means
			type_arr[i,j] = type_vec2[i][j]
		end
	end

	#turn to arr for solver
	cap_arr = Matrix{Float64}(undef,1,num_means)
	for i in 1:num_means
		cap_arr[i] = cap_vec[i]
	end

	d = (num_types,num_means,cap_arr,type_arr,type_vecprint,rtype_arr,type_probs)
	return d
end

"""
	QuantileVal(distribution, quant)
TEXT
"""
function QuantileVal(distribution, quant)
	d = 0.0
	if (distribution == "logistic")
		d = pdf(Logistic(),quantile(Logistic(),quant*(0.01)))
		return d
	elseif (distribution == "uniform")
		d = pdf(Uniform(),quantile(Uniform(),quant*(0.01)))
		return d
	else
		println("Error: distribution type not supported")
	end
end

end #module


#=
function data_gen_direct(ut_max,shocks_size)
	#gen random list for utilities
	ut_list = Float64[]
	for i in 1:ut_max
		append!(ut_list,11+i*rand())
	end
	shocks_list = Float64[]
	for i in 1:shocks_size
		append!(shocks_list,.01*i) #Int(floor(100*(i/shocks_size)))/100
	end
	#shocks_list = broadcast(*,shocks_list,1/sum(shocks_list))
	caps_list = Float64[]
	for i in 1:ut_max
		append!(caps_list,Int(floor(rand()*100))/100)
	end
	caps_list = broadcast(*,caps_list,1/sum(caps_list))
	frm_util = DataFrame(mean = ut_list)
	frm_shock = DataFrame(shock = shocks_list)
	frm_cap = DataFrame(cap = caps_list)

	#print(frm_cap)
	d = gen_processor(frm_util, frm_shock, "logistic", frm_cap)
	return d
end

function data_gen_cmd()
	##If command-line arguments are given, accept them
	#determines whether to write into file later

	utility_means = parse.(Float64,split(ARGS[2]))
	#println(utility_means)
	shocks = parse.(Float64,split(ARGS[3]))
	#println(shocks)
	shock_distribution = ARGS[4]
	capacities = parse.(Float64,split(ARGS[5]))
	#println(capacities)
	#sixth argument is name of file to which results are written

	frm_util = DataFrame(mean = utility_means)
	frm_shocks = DataFrame(shock = shocks)
	frm_cap = DataFrame(cap =capacities)
	name = chomp(ARGS[6])
	d = processor(frm_util,frm_shocks,shock_distribution,frm_cap)
	#CSV.write("$name", DataFrame(d), writeheader=false)
	#println("I'm working")
	#use JLD
	#the following line is the original line (it works); checking to see if it works for CSV
	file = jldopen("$name.jld", "w")
	write(file, "d", d)
	close(file)
end


if (size(ARGS)[1]>0)
	if (ARGS[1]=="cmd")
		data_gen_cmd()
	end
end
=#