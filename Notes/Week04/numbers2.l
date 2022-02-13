
%{

#include <stdio.h>

#include "tokens.h"

%}

%option noyywrap
%option yylineno

digit [0-9]
space [ \t\r\n]

%%

{digit}+              { return INT; }
{digit}+[.]{digit}+   { return REAL; }
{space}               { /* ignore */ }
.                     { return OTHER; }

%%


