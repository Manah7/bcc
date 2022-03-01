%{
#include <stdlib.h>
#include <stdio.h>
void yyerror(char *s);
struct Instruction{
  char instruction[128];
  int addresse;
  Instruction * jumpAddr;
};
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

%start Code
%%
Code :	RootElem
    |   RootElem Code;

RootElem : VarDec
    |   FonctionDec;

VarDec : Type tID tEOL
    |   Type tID ttASSIGN Val tEOL;

VarDec : Type tID tEOL
    |   Type tID ttASSIGN Val tEOL;

Type : tINT
    | tFLOAT 
    | tVOID;

Val : tNB_INT
    |   tNB_FLOAT;

FonctionIntDec : tINT tID tPO Args tPF Scope;

FonctionVoidDec : tVOID tID tPO Args tPF Scope;

FonctionFloatDec : tFLOAT tID tPO Args tPF Scope;

Scope : tAO CorpScope tAF;

CorpScope : CorpElem | CorpScope CorpElem;
CorpElem : VarDec | While | If | For;


%%

void yyerror(char *s) { fprintf(stderr, "%s\n", s); }
int main(void) {
  printf("Compilateur\n"); // yydebug=1;
  yyparse();
  return 0;
}
