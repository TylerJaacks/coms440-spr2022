
int A[50];
float B[50];

void test(char c)
{
  /* Mismatched types */
  c ? A : B;
}
