#include "utils.h"
#include "ts.h"
#include "operations.h"
#include <stdio.h>
#include <stdlib.h>

void bcc_print(const char *str){
    fprintf(stderr, str);
}

void panic(const char *str) {
    fprintf(stderr, "An error has been encountred: ");
    fprintf(stderr, str);
    exit(-3);
}

