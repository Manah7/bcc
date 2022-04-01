%{
#include <stdlib.h>
#include <stdio.h>
#include "y.tab.h"
%}

%option noyywrap

%%

[\t]+	{}
[\n]+   {}
"//".*$ {}

"while" { return tWHILE; }
"if" { return tIF; }
"else" { return tELSE; }
"for" { return tFOR; }

"main" { return tMAIN; }
"return" { return tRETURN; }

"int" { bcc_print("INT found in LEX\n");
    return tINT; }
"float" { return tFLOAT; }
"void" { return tVOID; }
"const" { return tCONST; }

"print" { return tPRINT; }

"goto" { return tGOTO; }
":" { return tLABEL; }

"==" { return tEGALEGAL; }
"+=" { return tPLUSEGAL; }
"-=" { return tMOINSEGAL; }
"++" { return tINCR; }
"--" { return tDINCR; }
"<<" { return tLSL; }
">>" { return tLSR; }
"="	{ return tASSIGN; }
"-"	{ return tSOU; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"^"	{ return tXOR; }
"&&" { return tAND; }
"||" { return tOR; }

"<" { return tINF; }
">" { return tSUP; }

";" { return tEOL; }
"," { return tVIRGULE; }

"&" { return tREF; }

"("	{ return tPO; }
")"	{ return tPF; }
"{" { return tAO; }
"}" { return tAF; }

-?[0-9]+(\.[0-9]+) {
	  yylval.nb = atof(yytext);
	  return tNB_FLOAT;
	}

-?[0-9]+ {
	  yylval.nb = atoi(yytext);
	  return tNB_INT;
	}

[a-zA-Z_]*[a-zA-Z_0-9]+ { 
    strncpy(yylval.var, yytext, 128);
    return tID;
    }

" " {}
.	{ return tERROR; }
