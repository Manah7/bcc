GRM=bcc.y
LEX=bcc.l
BIN=bcc

CC=gcc
CFLAGS=-Wall -g

OBJ=y.tab.o lex.yy.o ts.o utils.o functions.o operations.o main.o

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
	rm $(OBJ) y.tab.c y.tab.h lex.yy.c bcc y.output .gdb_history

