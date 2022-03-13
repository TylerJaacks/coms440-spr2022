
int mything(int N)
{
  int a, b, c, d;

  for (a=0; a<N; a++)
    for (b=0; b<N; b++)
      for (c=0; c<N; c++) {
        fputs("haha:", stdout);
        for (d=0; d<N; d++) {
          printf(d);
        }
        for (d=N; d; d--) {
          printf(d);
        }
        fputc(10, stdout);
      }
}

}
