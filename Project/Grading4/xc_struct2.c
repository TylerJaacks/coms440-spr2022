
struct basic {
  int x, y;
  char name[50];
  float depth;
};

int filler;

struct basic B;

struct basic { int nope, this, should, be, an, error; };

/* ^ compressed to ensure the line number of the error matches */
