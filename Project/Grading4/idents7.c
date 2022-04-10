
int A[50];

void foo(int A);  /* OK */

void bar(int a)
{
  float A[25];  /* also ok */
  int B;
  A;
}

void crux(char c)
{
  char A;
  A;
  B;  /* error */
  c;
}
