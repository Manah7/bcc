#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>

#include "utils.h"
#include "stack.h"

extern FILE *yyin;
extern yydebug;

/* BCC main entry */
int main(int argc, char* argv[]) {
    /* Hello messsage */
    bcc_print("BCC - Basic C Compiler\n");
    bcc_print("GNU GPL v3 - 2022\n");
    bcc_print("Manah <contact@manah.fr>, \nEnjmateo <Enjmateo@users.noreply.github.com>\n\n");

    /* Check arguments */
    if (argc < 2) {
        bcc_print("[!] Usage: bcc <file>\n");
        return 1;
    }

    if ((yyin = fopen(argv[1], "r")) == NULL) {
        bcc_print("[!] Error: File not found\n");
        return 1;
    }

    /* Launch parser */
    bcc_print("[+] Compiling...\n");
    yydebug = 0;
    yyparse();

    /* Output in file */
    bcc_print("[+] Parsing finished. Post treatement...\n");
    struct stat st = {0};
    if (stat("bin", &st) == -1) {
        mkdir("bin", 0775);
    }

    FILE *out = fopen("bin/prg.s", "w");
    unstack(out);

    /* Cleaning */
    fclose(out);
    bcc_print("[+] Done.\n");

    return 0;
}
