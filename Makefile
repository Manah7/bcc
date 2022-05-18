GRM=bcc.y
LEX=bcc.l
BIN=bcc

CC=gcc
CFLAGS=-Wall -g

OBJ=y.tab.o lex.yy.o ts.o utils.o stack.o operations.o main.o

PRG=bin/prg
CA=cross-assembler/ca2.py
FILE=1example.c

all: $(BIN)

%.o: %.c
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

y.tab.c: $(GRM)
	yacc -d -t -v $<

lex.yy.c: $(LEX)
	flex $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $@

clean:
	rm -f $(OBJ) y.tab.c y.tab.h lex.yy.c bcc y.output .gdb_history

objet:
	make
	./bcc < example/$(FILE) 1>bin/prg
	./$(CA)
	make clean

