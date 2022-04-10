
void foo(int a, char b);

int bar(float x);

char getchar();

int nest(int n);

void test()
{
  foo(3, '4');
  bar(5.6);
  getchar();

  foo(bar(5.7), getchar());

  nest(nest(nest(nest(nest(bar(7.6)))))); 
}
