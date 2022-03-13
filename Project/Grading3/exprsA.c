
// bad syntax for a complicated expression

int error(int a)
{
  int b;

  b = 
    ( 
      (a>0) 
      && 
      (a<10) 
    ) 
      || 
    ( 
      (a>20) 
      && 
      (a<30)

    /* )  "oops" */

  ;

  return b;
}

