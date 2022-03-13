
struct coords {
  int x, y;
};

void writeMessage(struct coords C, char message[]);

struct coords buildPoint(int a, int x, int y)
{
  struct coords C;

  /* ... */

  return C;
}

struct rectangle {
  struct coords top_left;
  struct coords bottom_right;
};

struct rectangle buildRect(struct coords tl, struct coords br);

