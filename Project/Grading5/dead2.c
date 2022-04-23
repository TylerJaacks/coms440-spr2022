
int A;

int bar()
{
    return 1;
}

int has_extra()
{
    return 2;
    A = 3;
    return bar();
}
