%{
#include <stdlib.h>
#include <stdio.h>
void yyerror(char *s);
%}

%union { int nb; char var[128]; float fnb; }
%token tWHILE tIF tELSE tFOR tRETURN  tGOTO tLABEL
%token tINT tFLOAT tVOID tCONST
%token tEGAL tPLUSEGAL tMOINSEGAL tINCR tDINCR tLSL tLSR tASSIGN tSOU tADD tMUL tXOR tAND tOR tINF tSUP
%token tEOL tVIRGULE
%token tREF
%token tPO tPF tAO tAF
%token tERROR

%token <nb> tNB_INT
%token <fnb> tNB_FLOAT
%token <var> tID

%start Compilateur
%%
Compilateur :	;
While : 
%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n"); // yydebug=1;
  yyparse();
  return 0;
}
