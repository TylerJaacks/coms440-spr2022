
int putchar(int c);

int print(float f)
{
  int d;
  d = (int) (f+0.1);
  putchar(d+48);
  f = f - (float) d;
  putchar(46);
  d = (int) (f * 10.0 + 0.1);
  putchar(d+48);
  return putchar(10);
}

float foo(float x)
{
  return x*2.0;
}

int main()
{
  return print(foo(3.1));
}
