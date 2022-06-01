#include "utils.h"
#include "ts.h"
#include "operations.h"
#include <stdio.h>
#include <stdlib.h>

extern yylineno;
char * filename;

FILE *file = NULL;

void bcc_print(const char *str){
    fprintf(stderr, str);
}

void init_utils(char * fn){
    filename = fn;
}

void print_line(int n) {
    int c = n ;
    char line [128];
    file  = fopen (filename, "r" );

    while (c > 0 && fgets(line,sizeof line, file)!= NULL){c--;}

    fprintf(stderr, "\t> %s\n", line);
}

void panic(const char *str) {
    fprintf(stderr, "\033[0;31m[!] An error has been encountred at line %d: ", yylineno);
    fprintf(stderr, str);
    print_line(yylineno);
    fprintf(stderr, "\033[0m");
    exit(4);
}

