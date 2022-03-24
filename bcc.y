%{
#include <stdlib.h>
#include <stdio.h>
#include "ts.h"
#include "utils.h"
#include "operations.h"

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
%type <nb> Maths

%start Code
%%
Code :	RootElem
    |   RootElem Code;

RootElem : VarDec
    |   FonctionDec;

Type : tINT {$$ = 1;
        bcc_print("Int détecté\n");}
    | tFLOAT {$$ = 2;}
    | tVOID {$$ = 0;};

VarDec : Type tID tEOL {add_ts($2, $1);
                        bcc_print("Ajouté à la table\n");}
    |   Type Affectation {add_ts($2, $1);};

Affectation : tID tASSIGN Operation tEOL {$$ = $1;};

Operation : {prof_plus();} Maths {prof_moins();};

// Opérations mathématiques retourne l'adresse de sortie
Maths : tID {$$ = get_symbol_addr($1);}
    | Maths tADD Maths {$$ = asm_add($1, $3);}
    | Maths tSOU Maths 
    | Maths tMUL Maths 
    | Maths tXOR Maths 
    | Maths tMUL Maths 
    | Maths tAND Maths 
    | Maths tOR Maths 
    | Maths tEGALEGAL Maths
    | Maths tLSL Maths 
    | Maths tLSR Maths
    | tNB_INT {$$ = asm_temp_val($1);}

Print : tPRINT tPO Maths tPF tEOL {};


PlusEgal : tID tPLUSEGAL Maths tEOL;
MoinsEgal : tID tMOINSEGAL Maths tEOL;


FonctionDec : FonctionMainDec 
            | FonctionIntDec
            | FonctionVoidDec 
            | FonctionFloatDec
            ;

FonctionMainDec : tINT tMAIN tPO tPF {printf("main:\n");} Scope ;

FonctionIntDec : tINT tID tPO Args tPF Scope{

};

FonctionVoidDec : tVOID tID tPO Args tPF Scope;

FonctionFloatDec : tFLOAT tID tPO Args tPF Scope;


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
    exit(4);
}
