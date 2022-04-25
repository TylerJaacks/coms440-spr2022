
int putchar(int c);

char print(int a, int b, int c, int d, int e, int f)
{
  putchar(a);
  putchar(b+32);
  putchar(c+32);
  putchar(d+32);
  putchar(e+32);
  putchar(f);
  return 'A';
}

int main()
{
  char c;
  c = print(putchar(72), putchar(69), putchar(76), putchar(76), putchar(79), putchar(10));
  return (int) c;
}
