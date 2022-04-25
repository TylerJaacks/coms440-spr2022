
int A;

void thing(int b)
{
    A = b;
}

int main()
{
    A = 0;
    thing(5);
    return A;
}
