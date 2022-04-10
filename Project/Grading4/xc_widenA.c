
char foo();
void bar();

void crust(int i, float f);

void test()
{
  crust(3, 4);
  crust(foo(), foo());

  foo(bar());

  crust(bar(), bar());  /* nope */
}
