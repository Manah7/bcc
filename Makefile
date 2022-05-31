GRM=src/bcc.y
LEX=src/bcc.l
BIN=bcc

SRC_DIR=src
OBJ_DIR=obj

CC=gcc
CFLAGS=-Wall -g -I$(SRC_DIR)

OBJ=y.tab.o lex.yy.o ts.o utils.o stack.o operations.o main.o

PRG=bin/prg
CA=cross-assembler/ca.py
ITR=interpreter/itr.py
FILE=examples/6example.c

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
	rm -fr $(OBJ) y.tab.c y.tab.h lex.yy.c bcc y.output .gdb_history bin/

example: clean all
	@./bcc $(FILE) 
	@echo
	@./$(CA)

demo: clean all
	@./bcc $(FILE)
	@echo
	@./$(CA)
	@echo
	@./$(ITR) 

