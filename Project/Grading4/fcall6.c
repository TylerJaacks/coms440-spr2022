
int thing(char X, int Y, float Z);

void test()
{
  char W;
  int X;
  float Y;

  W;
  X;
  Y;
  'A';
  'B';
  66;
  14;
  67.0;
  0.0;
  6.5;

  thing(W, X, Y);

  thing('A', 66, 67.0);

  thing(W, thing('B', 14, 0.0), 6.5);

  thing('A', 66); /* Error */
}
