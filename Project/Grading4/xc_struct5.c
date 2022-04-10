
/* Nested structs */

struct pair {
  int x, y;
};

struct window {
  struct pair upper_left;
  struct pair size;
  char title[256];
};

struct screen {
  struct window W[1000];  /* Ugly but we don't get pointers */
  int num_windows;
};

void test()
{
  struct pair P, p2;
  struct window W, w2;
  struct screen S, s2;

  P = p2;
  W = w2;
  S = s2;
}
