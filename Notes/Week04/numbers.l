
%{
#include <stdio.h>
%}

%option noyywrap

digit [0-9]
space [ \t\r\n]

%%

{digit}+              { printf("Got integer: %s\n", yytext); }
{digit}+[.]{digit}+   { printf("Got real   : %s\n", yytext); }
{space}*              { /* ignore */ }
.                     { fprintf(stderr, "Unexpected char: %s\n", yytext);
                        return 1; }

%%

int main()
{
  int code = yylex();
  fprintf(stderr, "Got code: %d\n", code);
  return 0;
}

