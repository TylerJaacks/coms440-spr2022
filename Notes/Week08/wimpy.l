
%{
#include "wimpy.tab.h"    // yacc gives me this, my token identifiers
int yywrap()
{
  return 1;
}
%}

%%

[0-9]+      { return NUMBER; }
"+"         { return PLUS; }
"*"         { return STAR; }
[ \t\r\n]   { }
.           { fprintf(stderr, "Ignoring strange character: '%s'\n", yytext); }

%%

