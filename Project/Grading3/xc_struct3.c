
struct S1 {
};

struct S2 {
  struct S1 nothing;
  int something;
};

struct S3 {
  struct S1 first;
  struct S2 second;
  int third;
};
