GRM=src/bcc.y
LEX=src/bcc.l
BIN=bcc

SRC_DIR=src
OBJ_DIR=obj

CC=gcc
CFLAGS=-Wall -g -I$(SRC_DIR)

OBJ=y.tab.o lex.yy.o ts.o utils.o stack.o operations.o main.o

PRG=bin/prg.s
VHD=bin/prg.vhd
CA=cross-assembler/ca.py
ITR=interpreter/itr.py
FILE=examples/6example.c
FILE_ERR=examples/7example_error.c
FILE_VHDL=examples/8example_vhdl.c

all: $(BIN)

%.o: $(SRC_DIR)/%.c 
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

y.tab.c: $(GRM)
	yacc -d -t -v $<

lex.yy.c: $(LEX)
	flex $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm -fr $(OBJ) y.tab.c y.tab.h lex.yy.c bcc y.output .gdb_history bin/ imported.vhd

example: clean all
	@./bcc $(FILE) 
	@echo
	@./$(CA)

demo: example
	@echo
	@./$(ITR) 

error: clean all
	@./bcc $(FILE_ERR) 

vhdl: clean all
	@./bcc $(FILE_VHDL)
	@echo
	@./$(CA) $(PRG) -f
	@echo "\n\e[1m"
	@cat $(VHD)
	@echo "\e[0m\n"
	@mv $(VHD) imported.vhd
	

