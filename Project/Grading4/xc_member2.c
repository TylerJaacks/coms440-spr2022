
struct thing1 {
  int x, y, z;
};

struct thing2 {
  float x;
  char y;
};

void test()
{
  struct thing1 T1;
  struct thing2 T2;

  T1;
  T1.x;
  T1.y;
  T1.z;

  T2;
  T2.x;
  T2.y;
  T2.z; /* error */
}
