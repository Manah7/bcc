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

%union { int nb; int addr; char var[128]; float fnb; }
%token tWHILE tIF tELSE tFOR tRETURN tGOTO tLABEL tPRINT
%token tINT tFLOAT tVOID tCONST
%token tEGALEGAL tPLUSEGAL tMOINSEGAL tINCR tDINCR tLSL tLSR tASSIGN tSOU tADD tMUL tDIV tXOR tAND tOR tINF tSUP
%token tEOL tVIRGULE
%token tREF tMAIN
%token tPO tPF tAO tAF
%token tERROR

%token <nb> tNB_INT
%type <nb> Type
%token <fnb> tNB_FLOAT
%token <var> tID
%type <var> Affectation
%type <addr> Maths

%start Code
%%
Code :	RootElem
    |   RootElem Code;

RootElem : VarDec
    |   FonctionDec;

Type : tINT {$$ = 1;}
    | tFLOAT {$$ = 2;}
    | tVOID {$$ = 0;};

VarDec : Type tID tEOL {add_ts($2, $1);}
    |   Type tID tASSIGN {$<addr>$ = add_ts($2, $1); prof_plus();} Maths tEOL {asm_assign_int_value($<addr>4, $5); prof_moins();};

// Opérations mathématiques retourne l'adresse de sortie
Maths : tID {$$ = get_symbol_addr($1);}
    | Maths tADD Maths {$$ = asm_add($1, $3);}
    | tPO Maths tPF {$$ = $2;}
    | Maths tSOU Maths {$$ = asm_sou($1, $3);}
    | Maths tMUL Maths {$$ = asm_mul($1, $3);}
    | Maths tDIV Maths {$$ = asm_div($1, $3);}
    | Maths tINF Maths {$$ = asm_inf($1, $3);}
    | Maths tSUP Maths {$$ = asm_sup($1, $3);}
/*    | Maths tXOR Maths 
    | Maths tMUL Maths 
    | Maths tAND Maths 
    | Maths tOR Maths 
    | Maths tEGALEGAL Maths
    | Maths tLSL Maths 
    | Maths tLSR Maths */
    | tNB_INT {$$ = asm_temp_val($1);}

Print : tPRINT tPO Maths tPF tEOL {asm_print($3);};


PlusEgal : tID tPLUSEGAL Maths tEOL{asm_plus_egal_int(get_symbol_addr($1),$3);};
MoinsEgal : tID tMOINSEGAL Maths tEOL;


FonctionDec : FonctionMainDec 
            | OtherFonctionDec;

FonctionMainDec : tINT tMAIN tPO tPF {printf("main:\n");} Scope ;

OtherFonctionDec : Type tID tPO Args tPF Scope;


Args : ;

Scope : tAO {prof_plus();} CorpScope tAF {prof_moins();};

CorpScope : CorpElem | CorpScope CorpElem;
CorpElem : VarDec | While | If | For | Affectation | PlusEgal | MoinsEgal | Scope | Print;

Affectation : tID tASSIGN Maths tEOL {asm_assign_int_value(get_symbol_addr($1), $3);};

If : tIF tPO Maths tPF tAO {prof_plus();} Scope tAF {asm_if($3);};

While : ;
For : ;


Error : tERROR{panic("Invalid string.");};

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s); 
    exit(4);
}
