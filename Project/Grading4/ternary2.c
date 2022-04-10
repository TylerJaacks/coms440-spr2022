
void foo();
void bar();

void tests(char t)
{
  int A[50];
  int B[50];

  t ? A : B;
  t ? foo() : bar();
}
