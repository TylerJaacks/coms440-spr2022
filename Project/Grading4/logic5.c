
void foo();
void bar();

void tests()
{
  foo() == bar();
  foo() != bar();
  foo() >  bar();
  foo() >= bar();
  foo() <  bar();
  foo() <= bar();
  foo() && bar();
  foo() || bar();
}
