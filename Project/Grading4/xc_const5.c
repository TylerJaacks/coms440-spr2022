
const float pi;

float radians(float degrees)
{
  return degrees * pi / 180.0;
}

float pi_f()
{
  return pi;
}

void tests()
{
  float x;
  x = pi;
  x = pi_f();
  x = radians(90.0);

  pi;
}
