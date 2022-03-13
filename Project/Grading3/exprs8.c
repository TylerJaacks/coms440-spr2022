
// casting

int approx(float x)
{
  int nx;

  nx = (int) x;

  return (int) ( (x-nx)*(x-nx)*x );
}

