%{
#include <iostream>
#include <cstdlib>
#include "calc.tab.h"

#define YY_DECL extern int yylex()
%}

%x COMMENT

breakLine \\\n

%%

^#                              BEGIN(COMMENT);
{breakLine}                     ;
[ \t]+                          ;
<COMMENT>{
    .|{breakLine}               ;
    \n                          BEGIN(INITIAL);
}
\n                              return NEWLINE;
[0-9]+                        { yylval = atoi(yytext); return NUM; }
\+                              return PLUS;
\-                              return MINUS;
\*                              return MULT;
\/                              return DIV;
\%                              return MOD;
\^                              return PWR;
\(                              return LBRACKET;
\)                              return RBRACKET;
.                               ;

%%

int yywrap() {
    return 1;
}