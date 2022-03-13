
int foo(int a)
{
  int x;

  x 
    = 
      a
        .
          ++    /* NOPE */
          member
          .
          y
          ;   
}
