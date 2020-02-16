module solve
	export mech_basic_cbc
	using JuMP
	using Cbc
	using GLPK
	using DataFrames
	using CSV
	using JLD
	using MathOptInterface
	const MOI = MathOptInterface

	#GENERATES AND SOLVES PROBLEM USING GLPK SOLVER
	function mech_basic_glpk(num_types,num_objects,type_arr,type_probs,cap_vec,folder,print_bool,infocon_bool,type_vec_shock)
		m = Model(with_optimizer(GLPK.Optimizer, tm_lim = 60000, msg_lev = GLPK.OFF))
		t = processor(num_types,num_objects,type_arr,type_probs,cap_vec,m,folder,print_bool,infocon_bool,type_vec_shock)
		return t
	end
	function mech_basic_glpk_cmd()
		d = load("$(ARGS[2]).jld")["d"]
		#println(d)
		num_types = d[1]
		num_objects = d[2]
		type_arr = d[3]
		type_probs = d[4]
		cap_vec = d[5]
		folder = d[6]
		m = Model(with_optimizer(GLPK.Optimizer, tm_lim = 60000, msg_lev = GLPK.OFF))
		t = processor(num_types,num_objects,type_arr,type_probs,cap_vec,m,folder)
		return t
	end

	###solves given model
	function processor(num_types,num_objects,type_arr,type_probs,cap_vec,m,folder,print_bool,infocon_bool,type_vec_shock)
		#turn cap_vec into an array
		#otherwise solver bricks, don't use 0-dim or vector

		cap_arr = Matrix{Float64}(undef,1,num_objects)
		for i in 1:num_objects
			cap_arr[i] = cap_vec[i]
		end

		T = num_types #rows, represents length of Theta
		A = num_objects #columns, represents length of A

		#m = Model(with_optimizer(GLPK.Optimizer, tm_lim = 60000, msg_lev = GLPK.OFF))

		#Alloc variable
		@variable(m, X[1:T,1:A])

		#capacity constraint
		@constraint(m, Ccon[j = 1:A], (transpose(type_probs)*X)[j] <= cap_arr[j])
		#println("Capacity constraint ",(transpose(type_probs)*X), "capacity ", cap_arr)

		#feasibility constraint
		ones_T = ones(T,1)
		ones_A = ones(A,1)
		#println("LHS ",size(X),"RHS ",size(ones_T))

		@constraint(m, Fcon, X*ones_A .<= ones_T)

		#non-negativity constraint
		@constraint(m, ncon, X .>= 0)

		if (infocon_bool == 1)
			#Incentive Compatibility constraint
			@constraint(m, con[i=1:T,j=1:T], add_to_expression!(sum( type_arr[i,k]*X[i,k] for k in 1:A),-sum( type_arr[i,k]*X[j,k] for k in 1:A))>= 0)
		end

		#objective
		@objective(m, Max, sum(type_probs[i]*(transpose(X[i,:])*type_arr[i,:]) for i in 1:T))
		#println("SOLVER PROB", type_probs[1])
		status = optimize!(m)

		#find argmax
		assignment_arr = Array{Float64}(undef, num_types,num_objects)
		for i in 1:num_types
			for j in 1:num_objects
				assignment = MOI.get(m, MOI.VariablePrimal(),X[i,j])
				if (assignment < 1*10^(-10))
					assignment = 0.0
				end
				assignment_arr[i,j] = assignment
			end
		end
		
		#turn assignment_arr into a dataframe
		assign_df = convert(DataFrame,assignment_arr)
		type_df = convert(DataFrame,type_arr)
		#current directory to allow for generalization
		if (print_bool == 1)
			if (infocon_bool == 1)
				alloc_designation = "info_constrained"
			end
			if (infocon_bool == 0)
				alloc_designation = "info_unconstrained"
			end
			CSV.write("$folder/a_data$alloc_designation@$num_objects,$num_types.csv", assign_df, writeheader=false)
			CSV.write("$folder/t_data$alloc_designation@$num_objects,$num_types.csv", type_df, writeheader=false)
			return (assignment_arr,type_arr,type_probs,type_vec_shock,alloc_designation)
		end
		if (print_bool == 0)
			return (assignment_arr,type_arr,type_probs,type_vec_shock)
		end#
	end

	#FOR GIVING ARGUMENTS BY COMMANDLINE, NOT RECOMMENDED
	if (size(ARGS)[1]>0)
		if (ARGS[1]=="cmd")
			mech_basic_cbc_cmd()
		end
	end

	#ALTERNATE MODELS, NOT CURRENTLY SUPPORTED
	function mech_basic_cbc(num_types,num_objects,type_arr,type_probs,cap_vec)
		m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))
		t = processor(num_types,num_objects,type_arr,type_probs,cap_vec,m)
		d = @elapsed t
		#println("cbc: ", d)
		return t
	end
	function mech_basic_cbc_cmd()
		d = load("$(ARGS[2]).jld")["d"]
		#println(d)
		num_types = d[1]
		num_objects = d[2]
		type_arr = d[3]
		type_probs = d[4]
		cap_vec = d[5]
		m = Model(with_optimizer(Cbc.Optimizer, logLevel=1))
		t = processor(num_types,num_objects,type_arr,type_probs,cap_vec,m)
		return t
	end

end #module
