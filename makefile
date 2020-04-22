#source path/to/virtualenv/bin/activate; 

all: run install display


run: solver/run_cmd.jl solve.o x_t.o gen.o
	julia solver/run_cmd.jl

x_t.o: solver/x_t.jl
	julia solver/x_t.jl

solve.o: solver/solve.jl
	julia solver/solve.jl

gen.o: solver/gen.jl
	julia solver/gen.jl

install:
	( \
		pip install -r requirements.txt; \
       )

display: dataPresentation.o solver/table_creator.py
	python3 solver/table_creator.py

dataPresentation.o: solver/data_presentation.py
	python3 solver/data_presentation.py


clean:
	rm -r *.jld
