run: solver/run_cmd.jl solve.o x_t.o gen.o
	julia solver/run_cmd.jl

x_t.o: solver/x_t.jl
	julia solver/x_t.jl

solve.o: solver/solve.jl
	julia solver/solve.jl

gen.o: solver/gen.jl
	julia solver/gen.jl

clean:
	rm -r *.jld
