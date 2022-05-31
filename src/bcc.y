%{
#include <stdlib.h>
#include <stdio.h>
#include "ts.h"
#include "utils.h"
#include "operations.h"
#include "stack.h"

int yylex();
void yyerror(char *s);

struct Instruction{
  char instruction[128];
  int addresse;
  struct Instruction * jumpAddr;
};
%}

%union { int nb; int addr; char var[128]; float fnb; }
%token tWHILE tIF tELSE tRETURN tPRINT
%token tINT tFLOAT tVOID
%token tEGALEGAL tPLUSEGAL tMOINSEGAL tLSL tLSR tASSIGN tSOU tADD tMUL tDIV tINF tSUP
%token tEOL
%token tPO tPF tAO tAF

%token <nb> tNB_INT
%type <nb> Type
%token <var> tID
%token <var> tMAIN
%type <var> Affectation
%type <addr> Maths
%type <addr> If

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
    | Maths tEGALEGAL Maths {$$ = asm_eq($1, $3);}
    | Maths tLSL Maths {$$ = asm_lsl($1, $3);}
    | Maths tLSR Maths {$$ = asm_lsr($1, $3);}
    | tNB_INT {$$ = asm_temp_val($1);}

Print : tPRINT tPO Maths tPF tEOL {asm_print($3);};


PlusEgal : tID tPLUSEGAL Maths tEOL{asm_plus_egal_int(get_symbol_addr($1),$3);};
MoinsEgal : tID tMOINSEGAL Maths tEOL{asm_moins_egal_int(get_symbol_addr($1),$3);};


FonctionDec : FonctionMainDec 
            | OtherFonctionDec;

FonctionMainDec : tINT tMAIN tPO tPF {add_stack_function($2);} Scope ;

OtherFonctionDec : Type tID tPO tPF {add_stack_function($2);} Scope ;

fctnCall : tID tPO tPF tEOL {pre_fnct(get_symbol_addr($1));};

Return : tRETURN tEOL {add_return();}; 

Scope : tAO {prof_plus();} CorpScope tAF {prof_moins();};

CorpScope : CorpElem | CorpScope CorpElem;
CorpElem : VarDec | While | If | IfElse | Affectation | PlusEgal | MoinsEgal | Scope | Print | fctnCall | Return;

Affectation : tID tASSIGN Maths tEOL {asm_assign_int_value(get_symbol_addr($1), $3);};

If : tIF Maths {prof_plus(); $<addr>$ = pre_if($2);} Scope {patch_if($<addr>3); prof_moins(); $$ = $<addr>3;};

IfElse : If tELSE {prof_plus(); $<addr>$ = pre_else($1);} 
        Scope 
        {patch_else($<addr>3); prof_moins();};

While : tWHILE Maths {prof_plus(); $<addr>$ = pre_while($2);} Scope {patch_while($<addr>3); prof_moins();};

%%

void yyerror(char *s) {
    fprintf(stderr, "[!] %s\n", s); 
    exit(4);
}
