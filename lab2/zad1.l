%{

#include<stdio.h>
int word_counter = 0;
int line_counter = 0;

%}

%%

^[[:blank:]]*(\n)?  ;
[[:blank:]]+$       ;
[[:blank:]]+        { fprintf(yyout, " "); }

[^[:blank:]|\n]+    { word_counter++; ECHO; }
\n/.                { line_counter++; fprintf(yyout, "\n"); yyless(1); }
\n                  ;

%%

int yywrap() {
    printf("Words: %d\nLines: %d", word_counter, line_counter+1);
    return 1;
}

int main(int argc, char **argv) {
    if ( argc > 1 ) {
        yyin = fopen(argv[1], "r");
        if (argc > 2) {
            yyout = fopen(argv[2], "w");
        } else {
            yyout = stdout;
        }
    } else {
        yyin = stdin;
    }
    
    return yylex();
}