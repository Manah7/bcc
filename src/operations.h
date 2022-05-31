#ifndef OPERATIONS_H
#define OPERATIONS_H

void asm_print(int addr);

/* Assign a const to an address */
void asm_assign_int_const(int addr, int value); 

/* Assign a value to an address */
void asm_assign_int_value(int addr, int value);

/* Plus égal */
void asm_plus_egal_int(int addr1, int addr2);

/* Ajoute deux valeurs et retourne l'adresse du résultat */
int asm_add(int addr1, int addr2);

int asm_temp_val(int value);


void asm_moins_egal_int(int addr1, int addr2);

int asm_sou(int addr1, int addr2);

int asm_mul(int addr1, int addr2);

int asm_div(int addr1, int addr2);

int asm_inf(int addr1, int addr2);

int asm_sup(int addr1, int addr2);

int asm_eq(int addr1, int addr2);

int asm_lsl(int addr1, int addr2);

int asm_lsr(int addr1, int addr2);

int asm_call_fctn(int addr);

#endif