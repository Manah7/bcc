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
void asm_assign_int_value(int addr, int value){
    printf("AFC %d %d", addr, value);    
}

void asm_plus_egal_int(int addr1, int addr2){
    printf("ADD %d %d %d", addr1, addr1, addr2);
}

int asm_add(int addr1, int addr2) {
    int dest = add_ts_wn();
    printf("ADD %d %d %d", dest, addr1, addr2);
    return dest;
}
