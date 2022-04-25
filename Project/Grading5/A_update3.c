
int A[15];

int test1()
{
  return A[1] += 8;
}

int test2(int i)
{
  int B[12];
  return B[i++] -= 11;
}
