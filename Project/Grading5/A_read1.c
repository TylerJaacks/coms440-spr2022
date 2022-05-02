
void test(float f);

void test1()
{
  char A[10];
  char c;

  c = A[3];
  return;
}

int A[11];

void test2(int b)
{
  b = A[2];
  return;
}

void test3(int i)
{
  float F[12];
  test(F[i]);
  return;
}
