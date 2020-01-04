This is for the general case with local data files. To find instructions for the 2x3 example, 
please refer to the proper "2x3_example" subdirectory for the correct Howto.md file.

To implement, please do as follows:

Clone the entire repository to your local machine.
cd to your Github directory, possibly by cd /Users/Name/Documents/Github

If they are not already present, move files of the following name to this directory:
util_data.csv
shock_data.csv
cap_data.csv

input the following commands:
julia basic-program/solver_basic/pkgs2add.jl
julia basic-program/solver_basic/problem_generator.jl
julia basic-program/solver_basic/problem_solver.jl
julia basic-program/solver_basic/CSV_gen.jl
julia basic-program/solver_basic/2x3_example/cs_script.jl
Check basic-program/solver_basic/assignment_data for output
