%{
#include <stdlib.h>
#include <stdio.h>
#include "ts.h"
#include "utils.h"

void yyerror(char *s);
struct Instruction{
  char instruction[128];
  int addresse;
  struct Instruction * jumpAddr;
};
%}

%union { int nb; char var[128]; float fnb; }
%token tWHILE tIF tELSE tFOR tRETURN tGOTO tLABEL tPRINT
%token tINT tFLOAT tVOID tCONST
%token tEGALEGAL tPLUSEGAL tMOINSEGAL tINCR tDINCR tLSL tLSR tASSIGN tSOU tADD tMUL tXOR tAND tOR tINF tSUP
%token tEOL tVIRGULE
%token tREF tMAIN
%token tPO tPF tAO tAF
%token tERROR

%token <nb> tNB_INT
%token <fnb> tNB_FLOAT
%token <var> tID
%type <nb> Type
%type <var> Affectation

%start Code
%%
Code :	RootElem
    |   RootElem Code;

RootElem : VarDec
    |   FonctionDec;

Type : tINT {return 1;}
    | tFLOAT {return 2;}
    | tVOID {return 0;};

VarDec : Type tID tEOL {add_ts($2, $1);}
    |   Type Affectation {add_ts($2, $1);};

Affectation : tID tASSIGN Maths tEOL {return $1;};

Operation : {prof_plus();} Maths {prof_moins();};

Maths : tID {return get_symbol_addr($1);}
    | MathTemp {return $1;};

MathTemp :  
      Maths tADD Maths {}
    | Maths tSOU Maths 
    | Maths tMUL Maths 
    | Maths tXOR Maths 
    | Maths tMUL Maths 
    | Maths tAND Maths 
    | Maths tOR Maths 
    | Maths tEGALEGAL Maths
    | Maths tLSL Maths 
    | Maths tLSR Maths
    | tNB_INT



PlusEgal : tID tPLUSEGAL Maths tEOL;
MoinsEgal : tID tMOINSEGAL Maths tEOL;


Val : tNB_INT
    | tNB_FLOAT;

FonctionDec : FonctionMainDec 
            | FonctionIntDec
            | FonctionVoidDec 
            | FonctionFloatDec
            ;

FonctionMainDec : tINT tMAIN tPO Args tPF Scope;

FonctionIntDec : tINT tID tPO Args tPF Scope{

};

FonctionVoidDec : tVOID tID tPO Args tPF Scope;

FonctionFloatDec : tFLOAT tID tPO Args tPF Scope;

Print : tPRINT tPO tID tPF tEOL {};

Args : ;

Scope : tAO {prof_plus();} CorpScope tAF {prof_moins();};

CorpScope : CorpElem | CorpScope CorpElem;
CorpElem : VarDec | While | If | For | Affectation | PlusEgal | MoinsEgal | Scope | Print;


While : ;
If : ;
For : ;


Error : tERROR{panic("Invalid string.");};

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s); 
}

int main(void) {
  printf("Compilateur\n"); 
  // yydebug=1;
  yyparse();
  return 0;
}
