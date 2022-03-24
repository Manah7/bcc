#include "utils.h"
#include "ts.h"
#include <stdio.h>
#include <stdlib.h>

void bcc_print(const char *str){
    fprintf(stderr, str);
}

void panic(const char *str) {
    fprintf(stderr, "An error has been encountred: ");
    fprintf(stderr, str);
    exit(-1);
}

void asm_print(const char *str){
    int addr = get_symbol_addr(str);
    printf("PRI %d", addr); 
}

/* Opérations sur INT */
void asm_assign_int_value(const char *name, int value){
    int addr = get_symbol_addr(name);
    printf("AFC %d %d", addr, value);    
}

void asm_plus_egal_int(const char *id1, const char *id2){
    int addr1 = get_symbol_addr(id1);
    int addr2 = get_symbol_addr(id2);
    printf("ADD %d %d %d", addr1, addr1, addr2);
}