
void tests(int a, float b, char c)
{
  int A;
  float B;
  char C;

  A = a = 2;
  B = b = 2.0;
  C = c = '2';

  A += a += 2;
  B += b += 2.0;
  C += c += '2';

  A -= a -= 2;
  B -= b -= 2.0;
  C -= c -= '2';

  A *= a *= 2;
  B *= b *= 2.0;
  C *= c *= '2';

  A /= a /= 2;
  B /= b /= 2.0;
  C /= c /= '2';
}
