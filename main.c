#include <stdio.h>
#include <stdlib.h>
#include "utils.h"
#include "stack.h"

/* BCC main entry */
int main(int argc, char* argv[]) {
    bcc_print("BCC - Basic C Compiler\n");

    extern yydebug;
    yydebug = 0;
    yyparse();

    unstack();

    return 0;
}