
// binary +, -, *, /, %

void bar(int a)
{
  int b;

  b = a + 1;
  a = b - 2;
  b = a * 3;
  a = b / 4;
  b = a % 5;
  a = b + a;
  b = a - b;
  a = b * a;
  b = a / b;
  a = b % a;
  b = 6 + a;
  a = 7 - b;
  b = 8 * a;
  a = 9 / b;
  b = 10 % a;

}
