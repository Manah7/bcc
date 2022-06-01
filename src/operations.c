#include "operations.h"
#include "stack.h"
#include "ts.h"

void asm_print(int addr){
    add_stack_op1("PRI", addr);
}

/* Opérations sur INT */
void asm_assign_int_const(int addr, int value){
    add_stack_op2("AFC", addr, value);   
}

void asm_assign_int_value(int addr, int valueaddr){
    add_stack_op2("COP", addr, valueaddr);
}

int asm_temp_val(int value){
    int dest = add_ts_wn();
    add_stack_op2("AFC", dest, value);
    return dest;   
}

///////// ADD /////////
void asm_plus_egal_int(int addr1, int addr2){
    add_stack_op3("ADD", addr1, addr1, addr2);
}

int asm_add(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("ADD", dest, addr1, addr2);
    return dest;
}

///////// SOU /////////
void asm_moins_egal_int(int addr1, int addr2){
    add_stack_op3("SOU", addr1, addr1, addr2);
}

int asm_sou(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("SOU", dest, addr1, addr2);
    return dest;
}

///////// MUL /////////
int asm_mul(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("MUL", dest, addr1, addr2);
    return dest;
}

///////// DIV /////////
int asm_div(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("DIV", dest, addr1, addr2);
    return dest;
}

///////// CMP /////////
int asm_inf(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("INF", dest, addr1, addr2);
    return dest;
}

int asm_sup(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("SUP", dest, addr1, addr2);
    return dest;
}

///////// EQU /////////
int asm_eq(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("EQU", dest, addr1, addr2);
    return dest;
}

///////// LS /////////
int asm_lsl(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("LSL", dest, addr1, addr2);
    return dest;
}

int asm_lsr(int addr1, int addr2) {
    int dest = add_ts_wn();
    add_stack_op3("LSR", dest, addr1, addr2);
    return dest;
}

