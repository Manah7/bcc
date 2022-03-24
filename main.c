#include <stdio.h>
#include <stdlib.h>
#include "utils.h"

/* BCC main entry */
int main(int argc, char* argv[]) {
    bcc_print("BCC - Basic C Compiler\n");

    extern yydebug;
    yydebug = 1;
    //FILE* fp = fopen(argv[1], "a");
    yyparse();

    return 1;
}