
int foo(int x);

void bar();

int cruft(int a)
{
  foo(a);
  bar();
  foo();  /* error */
}
