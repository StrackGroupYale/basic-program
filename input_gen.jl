#Inputs: num, means_vec
#Output file: num_types,num_objects,Util_vec,Dist_arr,Cap_Constraint_vec

using Distributions
using JuMP

#Accept User Input
function input_2_tuple()

  return meanscale_vec
end


#Shock Regime

function shock_gen_incr(shock_num,shock_base,shock_inc)
	shock = Vector{T}(float, n)
	for i:shock_num
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

function logistic(meanscale_vec)
    d[i]= Logistic(meanscale_vec[i],meanscale_vec[num+i]) ##create logistic function: mean, scale
end
    





