
%{
#include <stdio.h>
int yylex();
void yyerror(const char* msg)
{
  fprintf(stderr, "wimpy error: %s\n", msg);
}
%}

%token PLUS STAR NUMBER
%left PLUS
%left STAR

%%

expr  : expr PLUS expr { printf ("reducing +\n"); }
      | expr STAR expr { printf ("reducing *\n"); }
      | NUMBER
      ;

%%

int main()
{
  int c = yyparse();
  printf("Done, yyparse returned %d\n", c);
  return c;
}

