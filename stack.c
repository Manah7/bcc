#include <stdio.h>
#include <string.h>
#include "stack.h"
#include "utils.h"
#include "operations.h"
#include "ts.h"

#define STACK_SIZE 1024
#define SP_START 1

typedef struct
{
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
 *  - op == -3 : op doit être changé par un patch de fonction (définition)
 *  - op == -4 : op doit être changé par un patch de focntion (aller / retour)
 */

int stack_top = SP_START;
instruction stack[STACK_SIZE];


void add_stack_op1(char ins[3], int op1)
{
    strncpy(stack[stack_top].operande, ins, 3);
    stack[stack_top].op1 = op1;
    stack[stack_top].op2 = -1;
    stack[stack_top].op3 = -1;
    stack_top++;
}

void add_stack_op2(char ins[3], int op1, int op2)
{
    strncpy(stack[stack_top].operande, ins, 3);
    stack[stack_top].op1 = op1;
    stack[stack_top].op2 = op2;
    stack[stack_top].op3 = -1;
    stack_top++;
}

void add_stack_op3(char ins[3], int op1, int op2, int op3)
{
    strncpy(stack[stack_top].operande, ins, 3);
    stack[stack_top].op1 = op1;
    stack[stack_top].op2 = op2;
    stack[stack_top].op3 = op3;
    stack_top++;
}

void add_stack_function(char *name)
{
    bcc_print("[+] Adding function... \n");
    int addr = add_ts(name, tfunction);
    strncpy(stack[stack_top].operande, "FCT", 3);
    stack[stack_top].op1 = -3;
    stack[stack_top].op2 = addr;
    stack[stack_top].op3 = -1;
    stack_top++;
}

int get_fnct_stack(int addr)
{
    int sp = SP_START;
    while (stack_top > sp) {
        if (stack[sp].op1 == -3 && stack[sp].op2 == addr) {
            return sp;
        }
        sp++;
    }
    return -1;
}

/** @brief Unstack and apply modifier at the end of the parsing.
 *  Also apply corrector for function calls.
 **/
void unstack()
{
    bcc_print("[+] Unstacking: \n");
    int sp = SP_START;
    while (stack_top > sp)
    {
        if (stack[sp].op1 == -3)
        {
            //printf("\n");
            printf("%d\tNOP\n", sp);
            printf("%s: \n", get_symbol_name(stack[sp].op2));
            sp++;
            continue;
        }

        if (stack[sp].op1 == -4) {
            stack[sp].op1 = get_fnct_stack(stack[sp].op2) + 1;
            stack[sp].op2 = -1;
        }

        printf("%d\t", sp);
        printf("%s ", stack[sp].operande);
        if (stack[sp].op1 != -1)
        {
            printf("%d ", stack[sp].op1);
            if (stack[sp].op2 != -1)
            {
                printf("%d ", stack[sp].op2);
                if (stack[sp].op3 != -1)
                {
                    printf("%d", stack[sp].op3);
                }
            }
        }
        printf("\n");

        sp++;
    }
}

void add_return()
{
    bcc_print("[+] Adding return.\n");
    strncpy(stack[stack_top].operande, "RET", 3);
    stack[stack_top].op1 = -1;
    stack[stack_top].op2 = -1;
    stack[stack_top].op3 = -1;
    stack_top++;
}

int pre_if(int arg)
{
    bcc_print("[+] Entrée fonction pre_if\n");

    strncpy(stack[stack_top].operande, "JMF", 3);
    stack[stack_top].op1 = arg;
    stack[stack_top].op2 = -2;
    stack[stack_top].op3 = -1;

    return stack_top++;
}

void patch_if(int to_patch)
{
    bcc_print("[>] If done, patching...\n");
    stack[to_patch].op2 = stack_top;
}

int pre_while(int arg)
{
    bcc_print("[+] Entrée fonction pre_while\n");

    strncpy(stack[stack_top].operande, "JMF", 3);
    stack[stack_top].op1 = arg;
    stack[stack_top].op2 = -2;
    stack[stack_top].op3 = -1;

    return stack_top++;
}

void patch_while(int to_patch)
{
    bcc_print("[>] While done, end and patching...\n");

    add_stack_op1("JMP", to_patch - 1);
    stack[to_patch].op2 = stack_top;
}

int pre_fnct(int fctn_addr) {
    bcc_print("[+] Entrée fonction pre_fctn\n");

    strncpy(stack[stack_top].operande, "CAL", 3);
    stack[stack_top].op1 = -4;
    stack[stack_top].op2 = fctn_addr;
    stack[stack_top].op3 = -1;

    return stack_top++;
}
