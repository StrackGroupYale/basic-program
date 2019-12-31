In order to run data_gen.jl:
  1) add the following pkgs: Distributions,JuMP,CSV,DataFrames
  
  2) Make sure csv files are downloaded (check folder), and identify correct paths for each
  
  3) build data_gen.jl with include("/path/data_gen.jl")
  
  4) invoke data_gen("/path/util_data.csv","/path/dist_data.csv","logistic","/path/cap_data.csv")
  
  5) or
  
  6) invoke data_gen("/path/util_data.csv","/path/dist_data.csv","uniform","/path/cap_data.csv")

In order to solve:
  add the following pkgs: Distributions,JuMP,CSV,DataFrames,MathOptInterface
  Make sure csv files are downloaded (check folder), and identify correct paths for each
  build data_gen.jl with include("/path/data_gen.jl")
  build general_fxn.jl with include("/path/general_fxn.jl.jl")
  invoke compos_cbc("/path/util_data.csv","/path/dist_data.csv","logistic","/path/cap_data.csv")
  should yield cbc output with objective value and time taken
  should yield array with allocations
  
  
