
int A[50];

int foo(int i)
{
  A[3] = i;

  A[i]++;

  A[4] += 5;

  return i;
}

