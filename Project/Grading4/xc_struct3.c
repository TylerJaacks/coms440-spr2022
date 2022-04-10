
struct point {
  float x, y, z;
};

float Area(struct point P1, struct point P2, struct point P3);

float Area2(struct point Triangle[])
{
  return Area(Triangle[0], Triangle[1], Triangle[2]);
}
