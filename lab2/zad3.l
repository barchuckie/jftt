%{
    #include <stdio.h>

    int doc_flag = 0;
%}

%x SINGLE_COMMENT
%x MULTI_COMMENT
%x SINGLE_DOC
%x MULTI_DOC
%x STRING
%x INCLUDE

breakLine \\\n

singleLineDoc \/{breakLine}*\/{breakLine}*(\/|!)
multiLineDocOpen \/{breakLine}*\*{breakLine}*(\*|!)

singleLineComment \/{breakLine}*\/
mutliLineCommentOpen \/{breakLine}*\*

multiLineClose \*{breakLine}*\/

quote \"

includeOpen \<
includeClose \>

%%

{includeOpen}           { ECHO; BEGIN(INCLUDE); }
<INCLUDE>{
\\\\                    ECHO;
{breakLine}             ECHO;
\\\>                    ECHO;
{includeClose}          { ECHO; BEGIN(INITIAL); }
.                       ECHO;
}

{quote}                 { ECHO; BEGIN(STRING); }
<STRING>{
\\\\                    ECHO;
{breakLine}             ECHO;
\\\"                    ECHO;
{quote}                 { ECHO; BEGIN(INITIAL); }
.                       ECHO;
}

{singleLineComment}     BEGIN(SINGLE_COMMENT);
<SINGLE_COMMENT>{
.*{breakLine}           ;
\n                      { ECHO; BEGIN(INITIAL); }
.                       ;
}

{mutliLineCommentOpen}  BEGIN(MULTI_COMMENT);
<MULTI_COMMENT>{
{multiLineClose}        { BEGIN(INITIAL); }
.|\n                    ;
}

{singleLineDoc}         { 
    if (doc_flag) { 
        ECHO; BEGIN(SINGLE_DOC); 
    } else {
        BEGIN(SINGLE_COMMENT);
    }
}
<SINGLE_DOC>{
.*{breakLine}           ECHO;
\n                      { ECHO; BEGIN(INITIAL); }
.                       ECHO;
}

{multiLineDocOpen}      { 
    if (doc_flag) { 
        ECHO; BEGIN(MULTI_DOC); 
    } else {
        BEGIN(MULTI_COMMENT);
    }
}
<MULTI_DOC>{
{multiLineClose}        { ECHO; BEGIN(INITIAL); }
.|\n                    { ECHO; }
}

%%

int yywrap() {
    return 1;
}

void print_usage() {
    printf("Usage: zad3.exe [-doc] [-in file_name] [-out file_name]");
}

int main(int argc, char **argv) {
    for(int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-doc") == 0) {
            doc_flag = 1;
        } else if (strcmp(argv[i], "-in") == 0) {
            if (i + 1 < argc) {
                yyin = fopen(argv[i+1], "r");
                i++;
            } else {
                print_usage();
                return 1;
            }
        } else if (strcmp(argv[i], "-out") == 0) {
            if (i + 1 < argc) {
                yyout = fopen(argv[i+1], "w");
                i++;
            } else {
                print_usage();
                return 1;
            }
        } else {
            print_usage();
            return 1;
        }
    }
    
    return yylex();
}