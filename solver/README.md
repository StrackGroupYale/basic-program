This is for the general case with local data files. To find instructions for the 2x3 example, 
please refer to the proper "2x3_example" subdirectory for the correct Howto.md file.

To implement, please do as follows:

1) Clone the entire repository to your local machine.
2) cd to your Github directory, possibly by cd /Users/Name/Documents/Github

Now, there are two different methods of inputing data to this function. One (I) is to use the command line directly. The other (II) is to use a script.

I: Using the Command-Line<br/>
3a) Input the following commands:<br/>
julia basic-program/solver_basic/pkgs2add.jl <br/>
julia basic-program/solver_basic/problem_generator.jl "cmd" "mean vector" "shock vector" "distribution string" "capacity vector" "output file name" string.<br/> E.g.: julia basic-program/solver_basic/problem_solver.jl "cmd" "1 2" ".2 .3 .4" "logistic" ".4 .6"  "output"<br/>
julia basic-program/solver_basic/problem_solver.jl "cmd" "input file name string".<br/> E.g.: julia basic-program/solver_basic/problem_solver.jl"cmd" "output"<br/>

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


Compare 3 schools, 1 bad 1 intermediate 1 good, change relative position of intermediate school for 5-6 cases
See how optimal mechanism changes
compare with price mechanism: 100 points per student, students buy probabilities of different schools

Is optimal allocation efficient? As in, are seats left open?
How often are optimal allocations inefficient
Don't have to treat everyone equally

2 roads forward:
- add efficiency constraints
- implement quadratic price regime

Write output script which writes in Latex which type gets what allocation
Consider semantic examples:
3 schools, A B C, A \succsim B \succsim C,U= "2 1 0" "5 1 0" "1 1 0", C = ".1 1 1"
vary "5" between 2 and \infty and see how solution changes

Consider converting real data into data that is usable for solver


- One person works on visualization
  with HTML/PDF, runs on multiple versions of the problem
- One person implements the model with prices
- Efficiency considerations (solver can take constraints as argument)

For the efficiency solver, type into the command line:
  Rscript efficiency.R [path_to_utility] [path_to_assignment] [num_schools] [path_to_capacity]
