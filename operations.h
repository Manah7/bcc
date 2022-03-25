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


#endif