
// compicated comparisons with ( )

int bar(int a)
{
  int b;
  int c;

  c = ( (a>b) && (a>c) && (a>0) )
      ||
      ( (a<b) && (a<c) && (a<0) )
      ;


  return (a>=2) && (a<=10) && (a!=b) && (a==c) && (a>b) && (b<c) ;
}
