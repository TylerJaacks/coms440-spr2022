
void tests()
{
  int A[10];
  int B[10];

  /* All bad */

  A = B; 
  A += B;
  A -= B;
  A *= B;
  A /= B;

  A = 3;
  A += 3;
  A -= 3;
  A *= 3;
  A /= 3;
}
