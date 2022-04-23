
void test1()
{
  char A[12];
  A[0]  += '0';
  return;
}

void test2(int i)
{
  int A[12];
  A[i]  *= 49;
  return;
}

void test3(int i)
{
  float A[12];
  A[i-1] /= 3.0;
  return;
}

void test4(int i)
{
  char A[12];
  A[++i] -= '3';
  return;
}
