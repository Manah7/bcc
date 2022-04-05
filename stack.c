#include <stdio.h>
#include <string.h>
#include "stack.h"
#include "utils.h"
#include "operations.h"

#define STACK_SIZE 1024
#define SP_START 1

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

int stack_top = SP_START;
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
    int sp = SP_START;
    while (stack_top > sp) {
        printf("%d\t", sp);
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
    bcc_print("[+] Entrée fonction pre_if\n");

    strncpy(stack[stack_top].operande, "JMF", 3);
    stack[stack_top].op1 = arg;
    stack[stack_top].op2 = -2;
    
    return stack_top++;
}

void patch_if(int to_patch) {
    bcc_print("[>] If done, patching...\n");
    stack[to_patch].op2 = stack_top;
}

int pre_while(int arg) {
    bcc_print("[+] Entrée fonction pre_while\n");

    strncpy(stack[stack_top].operande, "JMF", 3);
    stack[stack_top].op1 = arg;
    stack[stack_top].op2 = -2;
    
    return stack_top++;
}

void patch_while(int to_patch) {
    bcc_print("[>] While done, end and patching...\n");

    add_stack_op1("JMP", to_patch - 1);
    stack[to_patch].op2 = stack_top;
}
