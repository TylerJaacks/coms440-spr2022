
// complicated arithmetic with ( )

int bar(int a)
{
  int b;
  int c;

  b = (a+5)*6;
  c = (a+b+c+1) / ( (a-b) * (b-c) * (c-a) + 1);

  return (a + -b - -c + -6) % (2+a*b*c*(a+1)*(b+1)*(c+1));
}

int flip(int a)
{
  return - - - - - - - - - - - - - - - - - - - - a;
}

float dist(float x1, float y1, float z1)
{
  float x2, y2, z2;

  return (x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2);
}
