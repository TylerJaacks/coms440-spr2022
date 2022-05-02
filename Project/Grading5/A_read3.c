
void test(float f);

int test1(int i)
{
  int A[17];
  return A[i];
}

void test2()
{
  int A[11];
  test1(A[2]);
  return;
}

void test3(int i)
{
  float A[12];
  test(A[test1(i)]);
  return;
}
