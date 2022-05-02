
void dummy_char(char a)
{
    return;
}

void dummy_int(int a)
{
    return;
}

void dummy_float(float a)
{
    return;
}

void func1(int a, char b, float c)
{
    dummy_int(a);
    dummy_char(b);
    dummy_float(c);
    return;
}

void func2(float x)
{
    int i;
    dummy_float(x);
    dummy_int(i);
    return;
}

void func3()
{
    char c;
    dummy_char(c);
    return;
}

void func4(int a, int b, int c, int d, int e, int f, int g)
{
  float x;
  dummy_int(g);
  dummy_float(x);
  return;
}
