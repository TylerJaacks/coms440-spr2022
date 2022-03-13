
struct point {
  float x;
  float y;
  float z;
};

struct triangle {
  struct point P[3];
};

struct point camera_pos;
struct point camera_pointing;
struct point camera_up;

void drawSurface(struct triangle S[], int num_triangles);

struct triangle buffer[1024];

