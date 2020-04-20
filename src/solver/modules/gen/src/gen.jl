
module gen

	export data_gen,data_gen_direct


	using Distributions
	using JuMP
	using CSV
	using DataFrames
	using JLD

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
			println("Error: distribution type not supported")
		end
		return d
	end

	function gen_processor(frm_util,frm_shocks,shock_distribution,frm_cap,)
		num_types = nrow(frm_shocks)^nrow(frm_util) #assuming shocks given with objects in row, each vector as a column
		num_objects = nrow(frm_util)

		#convert dataframe to matrix
		util_vec = Vector{Float64}(undef, nrow(frm_util))
		for i in 1:nrow(frm_util)
			#println(frm_util.mean[i][1])
			util_vec[i] = frm_util.mean[i][1]
		end

		shock_vec = Vector{Float64}(undef, nrow(frm_shocks))
		for i in 1:nrow(frm_shocks)
			shock_vec[i] = frm_shocks.shock[i][1]
		end

		cap_vec = Vector{Float64}(undef, nrow(frm_cap))
		for i in 1:nrow(frm_cap)
			cap_vec[i] = frm_cap.cap[i][1]
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
		type_vecprint = deepcopy(type_vector)
		
		#println("type vector",type_vector)
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
		for i in 1:(nrow(frm_shocks)^nrow(frm_util))
			type_probs[i] = type_probs[i]/total2
		end

		##Print "raw" types
		rtype_arr = Array{Float64}(undef, num_types,num_objects)
		for i in 1:num_types
			for j in 1:num_objects
				rtype_arr[i,j] = type_vector[i][j]
			end
		end
		#CSV.write("solver/assignment_data/rt_data@$num_objects,$num_types.csv", DataFrame(rtype_arr), writeheader=false)
		##generate types
		type_vec2 = Vector{Any}(undef, num_types)
		for i in 1:num_types

			#take into account the transformation
			for j in 1:nrow(frm_util)
				type_vector[i][j] = quantile(Logistic(),type_vector[i][j])
			end
			type_vec2[i] = broadcast(+,util_vec,type_vector[i])
		end

		#generate type_arr
		type_arr = Array{Float64}(undef, num_types,num_objects)
		for i in 1:num_types
			for j in 1:num_objects
				type_arr[i,j] = type_vec2[i][j]
			end
		end
		d = (num_types,num_objects,type_arr,type_probs,cap_vec,type_vecprint,rtype_arr)
		return d
	end
	"""
    data_gen(utility_means,shocks,shock_distribution,capacities)

	Returns double the number `x` plus `1`.
	"""
	function data_gen(utility_means,shocks,shock_distribution,capacities)
		frm_util = DataFrame(CSV.File(utility_means))
		frm_shocks = DataFrame(CSV.File(shocks))
		frm_cap = DataFrame(CSV.File(capacities))
		#print(frm_cap)
		d = gen_processor(frm_util,frm_shocks,shock_distribution,frm_cap)
		return d
	end

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

	#=
		
	=#
end #module
