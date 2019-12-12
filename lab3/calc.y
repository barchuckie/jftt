%{
#include <iostream>
#include <sstream>
#include <cmath>

bool error = false;
std::ostringstream output;
const std::string default_error = "invalid syntax";
std::string error_message = default_error;

int yylex();
void yyerror(const char *s);
%}

%token NUM
%token NEWLINE
%token LBRACKET
%token RBRACKET
%left PLUS MINUS
%left MULT MOD DIV
%right PWR
%precedence NEG

%%
input:
    %empty
    | input line
;

line:
    NEWLINE
    | expr NEWLINE   {
                        if(!error) {
                            output << "\nResult: " << $1;
                            std::string s = output.str();
                            output.str("");
                            output.clear();
                            std::cout << s << std::endl;
                        } else {
                            output.str("");
                            output.clear();
                            std::cout << std::endl;
                            error = false;
                        }
                    }
    | error NEWLINE 
;

expr:
    NUM                         { $$ = $1; output << $1 << " ";}
    | expr PLUS expr            { $$ = $1 + $3; output << "+ "; }
    | expr MINUS expr           { $$ = $1 - $3; output << "- "; }
    | expr MULT expr            { $$ = $1 * $3; output << "* "; }
    | expr DIV expr             { 
                                    output << "/ ";
                                    if($3 == 0) {
                                        error_message = "dividing by 0 is not allowed";
                                        yyerror("");
                                    } else {
                                        $$ =  floor((double) $1 / (double) $3);
                                    }
                                }
    | expr MOD expr             {
                                    output << "% ";
                                    if($3 == 0) {
                                        error_message = "dividing by 0 is not allowed";
                                        yyerror("");
                                    } else {
                                        $$ = $1 - floor((double) $1 / (double) $3) * $3;
                                    }
                                }
    | MINUS expr %prec NEG      { $$ = -$2; output << "~ "; }
    | expr PWR expr             {
                                    output << "^ ";
                                    if($3 < 0) {
                                        error_message = "negative exponent is not allowed";
                                        yyerror("");
                                    } else {
                                        $$ = pow($1, $3);
                                    }
                                }
    | LBRACKET expr RBRACKET   { $$ = $2; }
;
%%

void yyerror(const char *s) {
    if (error_message == default_error) {
        std::string s = output.str();
        output.str("");
        output.clear();
        std::cout << s << std::endl;
    } else {
        error = true;
    }

    std::cerr << "Error: " << error_message << std::endl;
    error_message = default_error;
    return;
}

int main() {
    return yyparse();
}