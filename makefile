#source path/to/virtualenv/bin/activate; 

all: run install display


run: src/solver/modules/gen/src/run_cmd.jl  solve.o x_t.o gen.o
	julia src/solver/modules/gen/src/run_cmd.jl

x_t.o: src/solver/modules/gen/src/x_t.jl
	julia src/solver/modules/gen/src/x_t.jl

solve.o: src/solver/modules/gen/src/solve.jl
	julia src/solver/modules/gen/src/solve.jl

gen.o: src/solver/modules/gen/src/gen.jl
	julia src/solver/modules/gen/src/gen.jl

install:
	( \
		pip install -r requirements.txt; \
       )

display: dataPresentation.o src/solver/modules/gen/src/table_creator.py
	python3 src/solver/modules/gen/src/table_creator.py

dataPresentation.o: src/solver/modules/gen/src/data_presentation.py
	python3 src/solver/modules/gen/src/data_presentation.py


clean:
	rm -r *.jld
