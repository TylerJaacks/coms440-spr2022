
int putchar(int c);

void myput(int a)
{
  putchar(putchar(a));
  return;
}

int main()
{
  putchar(72);
  putchar(101);
  myput(108);
  putchar(111);
  putchar(10);
  return 33;
}
