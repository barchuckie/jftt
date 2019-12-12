%{
    #include <stdio.h>
    #include <string.h>
    #include <stdlib.h>
    
    char* concat(const char* a, const char* b) {
        char* result = malloc(strlen(a) + strlen(b) + 1);
        
        strcpy(result, a);
        strcat(result, b);
        
        return result;
    }
    
    int wrongComment = 0;
    char* comment = "";
%}

%x  COMMENT
%x  CDATA
%x  PARAMETER

open    \<!--
close   -->

cdataOpen   \<!\[CDATA\[
cdataClose  ]]>

%%

\"              { ECHO; BEGIN(PARAMETER); }
<PARAMETER>{
\"              { ECHO; BEGIN(INITIAL); } 
.               ECHO;
}


{cdataOpen}     { ECHO; BEGIN(CDATA); }
<CDATA>{
.|\n            ECHO;
{cdataClose}    { ECHO; BEGIN(INITIAL); }
}

{open}          { comment = "<--"; wrongComment = 0; BEGIN(COMMENT); } 
<COMMENT>{
{close}         { 
    if (wrongComment) { 
        printf("%s-->", comment); 
    } 
    comment = ""; 
    wrongComment = 0; 
    BEGIN(INITIAL); 
}
--              { wrongComment = 1; comment = concat(comment, yytext); }
.|\n            { comment = concat(comment, yytext); }
}

%%

int yywrap() {
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