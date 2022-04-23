
void print(float x);

void test1(float A[])
{
  print(A[0]);
  return;
}

void test2(int n, float B[])
{
  test1(B);
  return;
}

float X[10];

void test3()
{
  test2(4, X);
  return;
}
