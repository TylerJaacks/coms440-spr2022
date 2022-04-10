
int A;
float B;
char C;

void tests(int a, float b, char c)
{
  A = ++a;
  B = b++;
  C = ++c;

  A = a--;
  B = --b;
  C = c--;
}
