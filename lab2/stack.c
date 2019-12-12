#include "stack.h"
#include<stdio.h>

stack* create_stack() {
    stack *new_stack = (stack*)malloc(sizeof(stack));
    new_stack->top = -1;
    return new_stack;
}

int is_empty(stack* s) {
    return s->top < 0;
}

int push(int val, stack *s) {
    if (s->top == STACK_SIZE - 1)
        return -1;
    
    s->top++;
    s->stack[s->top] = val;

    return 0;
}

int* pop(stack *s) {
    if (s->top == -1) {
        return NULL;
    }

    int* popped = &(s->stack[s->top]);
    s->top--;
    return popped;
}