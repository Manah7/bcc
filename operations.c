#include "operations.h"
#include "ts.h"

void asm_print(int addr){
    printf("PRI %d", addr); 
}

/* Opérations sur INT */
void asm_assign_int_const(int addr, int value){
    printf("AFC %d %d", addr, value);    
}

void asm_assign_int_value(int addr, int valueaddr){
    printf("COP %d, %d", addr, valueaddr); 
}

void asm_plus_egal_int(int addr1, int addr2){
    printf("ADD %d %d %d", addr1, addr1, addr2);
}

int asm_add(int addr1, int addr2) {
    int dest = add_ts_wn();
    printf("ADD %d %d %d", dest, addr1, addr2);
    return dest;
}

int asm_temp_val(int value){
    int dest = add_ts_wn();
    printf("AFC %d %d", dest, value);
    return dest;   
}
