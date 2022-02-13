
#include <stdio.h>
#include "tokens.h"

int yylex();

extern int yylineno;
extern char* yytext;

int main()
{
    int code;
    yylineno = 1;

    while ( (code = yylex()) )
    {
        printf("On line %2d got token %d text %s\n",
                yylineno, code, yytext);
    }

    return 0;
}
