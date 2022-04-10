
struct pair {
  int x, y;
};

void naughty(float x, float y)
{
  struct pair {
    float x, y;
    char what;
  };

  struct pair P;
  P.x;
  P.y;
  P.what;

  P.x = x;
  P.y = y;
}

void test(int x, int y)
{
  struct pair P;
  P.x;
  P.y;

  P.x = x;
  P.y = y;
}

void nope()
{
  struct pair P;
  P;
  P.what;
}
