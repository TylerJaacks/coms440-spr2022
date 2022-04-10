
void nope(int A[]);

void test()
{
  int a[50];
  char c[50];

  nope(a);  /* Ok */
  nope(c);  /* error */
  a[1] = c[2];
}
