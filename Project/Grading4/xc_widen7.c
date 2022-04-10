
void foo(int a);
void bar(float x);

void test()
{
  foo('3');
  foo(3);

  bar('3');
  bar(3);
  bar(3.0);
}
