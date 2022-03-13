
int two(int a, int b);
int three(int a, int b, int c);
int four(int a, int b, int c, int d);

int bar(int a)
{
  int b;

  b = two(1, 2);
  b += three(3, 4, 5);
  b += four(6, 7, 8, 9);

  return b;
}
