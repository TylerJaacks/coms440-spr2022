
void test1()
{
  struct local {
    int a, b, c;
  };
  
  struct local L;
  L;
}

void test2()
{
  struct local L;     /* NOPE */
}
