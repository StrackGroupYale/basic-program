MAKEFILE
In order to run data_gen.jl:
  add the following pkgs: Distributions,JuMP,CSV,DataFrames
  Make sure csv files are downloaded (check folder), and identify correct paths for each
  build data_gen.jl with include("/path/data_gen.jl")
  invoke data_gen("/path/util_data.csv","/path/dist_data.csv","logistic","/path/cap_data.csv")
  or
  invoke data_gen("/path/util_data.csv","/path/dist_data.csv","uniform","/path/cap_data.csv")

In order to solve:
  add the following pkgs: Distributions,JuMP,CSV,DataFrames,MathOptInterface
  Make sure csv files are downloaded (check folder), and identify correct paths for each
  build data_gen.jl with include("/path/data_gen.jl")
  build general_fxn.jl with include("/path/general_fxn.jl.jl")
  invoke compos_cbc("/path/util_data.csv","/path/dist_data.csv","logistic","/path/cap_data.csv")
  should yield cbc output with objective value and time taken
  should yield array with allocations
  
  
