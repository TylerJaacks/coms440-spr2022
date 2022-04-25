
void test1(char A[])
{
  char c;
  c = A[0];
  return;
}

void test2(int n, char B[])
{
  test1(B);
  return;
}

void test3()
{
  char C[4];
  test2(4, C);
  return;
}
