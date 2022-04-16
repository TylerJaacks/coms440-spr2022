/*
  Computes and prints the first 20 Fibonacci numbers.
*/

void print(int x)
{
  if (x<0) {
    putchar(45);
    print(-x);
    return;
  }
  if (x>9) {
    print(x/10);
  }
  x = x % 10;
  putchar(48+x);
}

void print_two(int x)
{
  if (x>9) {
    putchar(48 + x/10);
  } else {
    putchar(32);
  }
  putchar(48 + x % 10);
  putchar(32);
  putchar(58);
  putchar(32);
}

int main()
{
  int i, f1, f2, f3;
  f1 = 0;
  f2 = 1;
  print_two(0);
  print(0);
  putchar(10);
  i=40;
  while (i) {
    print_two(40 - --i);
    print(f2);
    putchar(10);
    f3 = f1 + f2;
    f1 = f2;
    f2 = f3;
  }
  return 0;
}
