
%token number plus star

%%

S : S plus P
  | P
  ;

P : P star number
  | number
  ;

%%
