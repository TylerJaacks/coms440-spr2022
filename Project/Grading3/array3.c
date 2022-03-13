
int bar(int a)
{
  int A[50];

  A[0] = 0;
  A[1] = 1;

  for (a=2; a<50; a++) {
    A[a] = A[a-1] + A[a-2];
  }

  return A[49];
}

int strange(int A[])
{
  int b;

  b = A[ A[0]++ ] + A[ 2+A [ ++A[3] ] ];

  A[b] =  A[
            A[
              A[
                2
                *
                A[
                  A[0] + A[1] + A[2] + A[3]
                ]
                -
                A[4]
              ]
              +
              A[
                A[6] + A[7]
              ]--
            ]++
          ]--
          +
          7
          ;

  return 3;
}
