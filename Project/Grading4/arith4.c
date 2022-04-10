
void foo();
void bar();

void test()
{
  /* These are all bad */

  3 + foo();
  foo() + 3;
  foo() - 3;
  foo() * 3;
  foo() / 3;
  foo() % 3;
  foo() & 3;
  foo() | 3;
}

