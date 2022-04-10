
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
  struct pair P;
  struct window W;
  struct screen S;

  P;

  P.x;
  P.y;

  W;
  W.upper_left;
  W.upper_left.x;
  W.upper_left.y;
  W.size;
  W.size.x;
  W.size.y;
  W.title;
  W.title[0];

  S;
  S.num_windows;
  S.W;
  S.W[1];
  S.W[2].upper_left;
  S.W[3].upper_left.x;
  S.W[4].title;
  S.W[5].title[6];
}

