
/* Illegal ++ chaining */

int error(int a)
{
  int b;

  b = 
    (
    ++
    a
    )
    ++
  ;

  return 
    ++
    (
    b
    ++
    )
  ;
}
