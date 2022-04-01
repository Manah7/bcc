#include <stdio.h>
#include <string.h>
#include "stack.h"
#include "operations.h"

#define STACK_SIZE 1024

typedef struct {
    char operande[3];
    int op1;
    int op2;
    int op3;
    int depth;
} instruction;

/**
 * Conventions :
 *  - op == -1 : op non utilisé
 *  - op == -2 : op doit être changé par un patch de boucle
 */

int stack_top = 0;
instruction stack[STACK_SIZE];

void add_stack_op1(char ins[3], int op1) {
    strncpy(stack[stack_top].operande, ins, 3);
    stack[stack_top].op1 = op1;
    stack[stack_top].op2 = -1;
    stack[stack_top].op3 = -1;
    stack_top++;
}

void add_stack_op2(char ins[3], int op1, int op2) {
    strncpy(stack[stack_top].operande, ins, 3);
    stack[stack_top].op1 = op1;
    stack[stack_top].op2 = op2;
    stack[stack_top].op3 = -1;
    stack_top++;
}

void add_stack_op3(char ins[3], int op1, int op2, int op3) {
    strncpy(stack[stack_top].operande, ins, 3);
    stack[stack_top].op1 = op1;
    stack[stack_top].op2 = op2;
    stack[stack_top].op3 = op3;
    stack_top++;
}

void unstack() {
    int sp = 0;
    while (stack_top > sp) {
        printf("%s ", stack[sp].operande);
        printf("%d ", stack[sp].op1);

        if (stack[sp].op2 != -1) {
            printf("%d ", stack[sp].op2);
            if (stack[sp].op3 != -1) {
                printf("%d", stack[sp].op3);
            }
        }
        printf("\n");
        
        sp++;
    }
}

int pre_if(int arg) {
    int zero = asm_temp_val(0);
    int eq = asm_eq(zero, arg);
    strncpy(stack[stack_top].operande, "JMF", 3);
    stack[stack_top].op1 = eq;
    stack[stack_top].op2 = -2;
    
    stack_top++;
    return stack_top - 1;
}

void patch_if(int to_patch, int to_patch_with) {
    stack[to_patch].op2 = to_patch_with;
}
