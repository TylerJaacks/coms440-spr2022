
int a, b, c;
float x, y, z;

void tests(char p, char q, char r)
{
  c ? b : a;
  c ? x : y;
  c ? p : q;

  x ? a : b;
  x ? y : z;
  x ? p : q;

  p ? a : b;
  p ? x : y;
  p ? q : r;
}
