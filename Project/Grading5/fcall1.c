
/*
  Check assembly for the following in function main():

  (1) There should be three calls to
      invokestatic Method fcall1 func1 (II)V

      -> Function call

  (2) First call: right before, we have

      iconst_1
      iconst_2

      -> Parameter set up

  (3) Second call: right before, we have

      iload_0
      iload_0

      -> Parameter set up

  (4) Third call: right before, we have something like

      iload_0
      iconst_1
      iadd
      iload_0
      iconst_2
      imul

      -> Parameter set up

  (5) There should be two calls to
      invokestatic Method fcall1 func2 (III)F

      -> Function call

  (6) Before the first call, we have

      iconst_3
      iconst_4
      iconst_5

      -> Parameter set up

  (7) Before the second call, we have something like

      bipush 72
      invokestatic Method libc putchar (I)I
      bipush 105
      invokestatic Method libc putchar (I)I
      bipush 10
      invokestatic Method libc putchar (I)I

      -> Parameter set up
      -> Correct calls to built-in putchar


  (8) At the end, we have something like

      invokestatic Method libc getchar ()I
      invokestatic Method fcall1 lower (I)I
      ireturn

      -> Function call
      -> Correct calls to built-in getchar
      -> int returns


  Check assembly for the following in function func1:

  (9) At the end, we have

      return

      -> void returns


  Check assembly for the following in function func2:

  (10) At the end, we have

      fload_2
      freturn

      -> float returns

  Check assembly for the following in function lower:

  (11) At the end, we have

      iload_0
      bipush 32
      iadd
      ireturn

      -> int returns
*/

int getchar();
int putchar(int c);

void func1(int a, int b)
{
  a = 3;
  b = 4;
  return;
}

float func2(int a, int b, int c)
{
  float f;
  f = (float) a;
  f /= (float) b;
  return f;
}

int lower(int a)
{
  return a+32;
}

int main()
{
  int i;
  func1(1, 2);

  i = 0;
  func1(i, i);

  func1(i+1, i*2);


  func2(3, 4, 5);

  func2(putchar(72), putchar(105), putchar(10));

  return lower(getchar());
}
