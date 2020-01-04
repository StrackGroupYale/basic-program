This is for the general case with local data files. To find instructions for the 2x3 example, 
please refer to the proper "2x3_example" subdirectory for the correct Howto.md file.

To implement, please do as follows:

1) Clone the entire repository to your local machine.
2) cd to your Github directory, possibly by cd /Users/Name/Documents/Github

3) If they are not already present, move files of the following name to this directory: <br/>
util_data.csv <br/>
shock_data.csv <br/>
cap_data.csv

4) Input the following commands:<br/>
julia basic-program/solver_basic/pkgs2add.jl <br/>
julia basic-program/solver_basic/problem_generator.jl <br/>
julia basic-program/solver_basic/problem_solver.jl <br/>
julia basic-program/solver_basic/CSV_gen.jl <br/>
julia basic-program/solver_basic/gen_cs_script.jl <br/>
5) Check basic-program/solver_basic/assignment_data for output
