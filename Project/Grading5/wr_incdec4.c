
int G;

void test1()
{
  int a;
  a--;
  return;
}

void test2()
{
  float b;
  b--;
  return;
}

int test3(int c)
{
  return c--;
}

float test4(float d)
{
  return d--;
}

void test5()
{
  G--;
  return;
}

int test6()
{
  return G--;
}
