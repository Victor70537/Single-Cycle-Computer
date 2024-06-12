CC = iverilog

ASM = python
args = `arg="$(filter-out all $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

SIM = vvp
SIMFLAGS = -lx2 > run.log

WAVE = gtkwave

all: clean assemble build simulate run
	@echo done

fifo.vvp: ./*.v
	$(CC) -o fifo.vvp IO.v IO_test.v 

gtkwave: 
	$(WAVE) dump.lx2 wave.gtkw

assemble: 
	$(ASM) AssemblyStuff/parser/assembler.py $(args) 

build: fifo.vvp

simulate: build
	$(SIM) fifo.vvp $(SIMFLAGS)

run: gtkwave

clean:
	rm fifo.vvp