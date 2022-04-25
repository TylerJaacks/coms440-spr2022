
int test1(int A[])
{
  return A[0];
}

void test2(int n, int B[])
{
  test1(B);
  return;
}

void test3()
{
  int C[4];
  test2(4, C);
  return;
}
