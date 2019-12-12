/* 
    stack.h
    Autor: Patryk Barczak
*/
#include <stdlib.h>

#define STACK_SIZE 256

typedef struct stack {
    int stack[STACK_SIZE];
    int top;
} stack;

stack* create_stack(); 

int is_empty(stack *s);

int push(int val, stack *s);

int* pop(stack *s);