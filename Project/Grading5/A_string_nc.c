
void test1(char A[])
{
  char c;
  c = A[0];
  return;
}

char test2(int n, char B[])
{
  return B[n];
}

void test3()
{
  test1("Hello");
  return;
}

void test4()
{
  char x;
  x = test2(5, "world!");
  return;
}

