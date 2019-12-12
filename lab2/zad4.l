%{
#include<math.h>
#include <stdlib.h>

#define STACK_SIZE 256

typedef struct stack {
    int stack[STACK_SIZE];
    int top;
} stack;

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

stack *s;
%}

%x IN_ERROR

%%
-?[0-9]+  { int num = atoi(yytext); push(num, s); }

\+      { 
    int *b = pop(s);
    int *a = pop(s);

    if (a == NULL || b == NULL) {
        printf("Blad: za mala liczba argumentow\n");
        BEGIN(IN_ERROR);
    } else {
        int result = *a + *b;
        push(result, s);
    }
}

\-      { 
    int *b = pop(s);
    int *a = pop(s);

    if (a == NULL || b == NULL) {
        printf("Blad: za mala liczba argumentow\n");
        BEGIN(IN_ERROR);
    } else {
        int result = *a - *b;
        push(result, s);
    }
}

\*      { 
    int *b = pop(s);
    int *a = pop(s);

    if (a == NULL || b == NULL) {
        printf("Blad: za mala liczba argumentow\n");
        BEGIN(IN_ERROR);
    } else {
        int result = *a * *b;
        push(result, s);
    }
}

\^      { 
    int *b = pop(s);
    int *a = pop(s);

    if (a == NULL || b == NULL) {
        printf("Blad: za mala liczba argumentow\n");
        BEGIN(IN_ERROR);
    } else {
        int result = pow(*a, *b);
        push(result, s);
    }
}

\%      { 
    int *b = pop(s);
    int *a = pop(s);

    if (a == NULL || b == NULL) {
        printf("Blad: za mala liczba argumentow\n");
        BEGIN(IN_ERROR);
    } else {
        int result = *a % *b;
        push(result, s);
    }
}

\/      {
    int *b = pop(s);
    int *a = pop(s);

    if (a == NULL || b == NULL) {
        printf("Blad: za mala liczba argumentow\n");
        BEGIN(IN_ERROR);
    } else {
        if (*b == 0) {
            printf("Blad: nie mozna dzielic przez 0\n");
            BEGIN(IN_ERROR);
        } else {
            int result = *a / *b;
            push(result, s);
        }
    }
}

\n      {
    int *result = pop(s);

    if (!is_empty(s)) {
        printf("Blad: za mala liczba operatorow\n");
    } else if (result == NULL) {
        printf("Blad: brak danych\n");
    } else {
        printf("= %d\n", *result);
    }
    free(s->stack);        
    free(s);
    s = create_stack();
}

[^[:blank:]]    {
    printf("Blad: zly znak \'%s\'", yytext);
    BEGIN(IN_ERROR);
}

[[:blank:]]     ;

<IN_ERROR>\n  {
    free(s->stack);        
    free(s);
    s = create_stack();
    BEGIN(INITIAL); 
}
<IN_ERROR>.  ;

%%

int yywrap() {
    return 1;
}

int main() {
    s = create_stack();

    return yylex();
}