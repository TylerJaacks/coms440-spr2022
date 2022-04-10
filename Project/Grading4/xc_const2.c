
int test1(const int i)
{
  return i + 3;
}

int test2(int a)
{
  return test1(a) + test1(a+3);
}

void test3(const int i)
{
  test1(i);
  test2(i);
}

void test4(const int i)
{
  i++;
}
