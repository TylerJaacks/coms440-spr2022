
void test(int a)
{
    a;
}

void strange(int x)
{
    test(x);
}

void bizarre()
{
    strange(test(4));
}
