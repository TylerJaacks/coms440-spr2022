
/* Basic ++, -- */

int bar(int a)
{
  int b;

  b = a;

  a++;
  ++b;

  a--;
  --b;

  return a == b;
}
