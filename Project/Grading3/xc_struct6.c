
struct pair {
  float x;
  float y;
};

struct pair p1, p2, p3;

struct quadrilateral {
  struct pair p1, p2, p3, p4;
};

int is_convex(struct quadrilateral q);

struct pair center(struct quadrilateral q);

float quad_area(struct quadrilateral q)
{
  struct triangle {
    struct pair p1, p2, p3;
  };

  struct triangle T[4];

  /* TBD */
  return 7.0;
}

