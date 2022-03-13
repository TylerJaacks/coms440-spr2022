
%token number

%%

S : S '+' P
  | P
  ;

P : P '*' number
  | number
  ;

%%
