This is for the general case with local data files. To find instructions for the 2x3 example, 
please refer to the proper "2x3_example" subdirectory for the correct Howto.md file.

To implement, please do as follows:

1) Clone the entire repository to your local machine.
2) cd to your Github directory, possibly by cd /Users/Name/Documents/Github

Now, there are two different methods of inputing data to this function. One (I) is to use the command line directly. The other (II) is to use a script.

I: Using the Command-Line<br/>
3a) Input the following commands:<br/>
julia basic-program/solver_basic/pkgs2add.jl <br/>
julia basic-program/solver_basic/problem_generator.jl "cmd" "mean vector" "shock vector" "distribution string" "capacity vector" -- "output file name" string. E.g. "cmd" "1 2" ".2 .3 .4" "logistic" ".4 .6"  "output"<br/>
julia basic-program/solver_basic/problem_solver.jl "cmd" "input file name string". E.g. "cmd" "output"<br/>

II: Using a Script<br/>
3b) If they are not already present, move files of the following name to this directory: <br/>
util_data.csv <br/>
shock_data.csv <br/>
cap_data.csv

4b) Input the following commands:<br/>
julia basic-program/solver_basic/pkgs2add.jl <br/>
julia basic-program/solver_basic/problem_generator.jl <br/>
julia basic-program/solver_basic/problem_solver.jl <br/>
julia basic-program/solver_basic/exec_and_time.jl <br/>
julia basic-program/solver_basic/gen_cs_script.jl <br/>
5b) Check basic-program/solver_basic/assignment_data for output
