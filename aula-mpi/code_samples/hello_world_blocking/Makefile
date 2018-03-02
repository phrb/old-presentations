OUTPUT=hello_world_blocking
MCC=mpicc
CC_OPT=-fopenmp

.PHONY: all

all: $(OUTPUT)

$(OUTPUT): $(OUTPUT).c
	$(MCC) -o $(OUTPUT) $(OUTPUT).c $(CC_OPT)

.PHONY: clean
clean:
	rm $(OUTPUT)
