#ifndef STACK_H
#define STACK_H

void add_stack_op1(char ins[3], int op1);
void add_stack_op2(char ins[3], int op1, int op2);
void add_stack_op3(char ins[3], int op1, int op2, int op3);

void unstack();

int pre_if(int arg);
void patch_if(int to_patch, int to_patch_with);

#endif