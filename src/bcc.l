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

"main" { strncpy(yylval.var, "main", 128);
        return tMAIN; }
"return" { return tRETURN; }

"int" { return tINT; }
"float" { return tFLOAT; }
"void" { return tVOID; }
"print" { return tPRINT; }

"==" { return tEGALEGAL; }
"+=" { return tPLUSEGAL; }
"-=" { return tMOINSEGAL; }
"<<" { return tLSL; }
">>" { return tLSR; }
"="	{ return tASSIGN; }
"-"	{ return tSOU; }
"+"	{ return tADD; }
"*"	{ return tMUL; }
"/"	{ return tDIV; }

"<" { return tINF; }
">" { return tSUP; }

";" { return tEOL; }

"("	{ return tPO; }
")"	{ return tPF; }
"{" { return tAO; }
"}" { return tAF; }

-?[0-9]+(\.[0-9]+) {
	  yylval.nb = atof(yytext);
       return -255; 
	  //return tNB_FLOAT;
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
.	{ printf("[!] Erreur lexicale : %s\n", yytext); exit(1); }