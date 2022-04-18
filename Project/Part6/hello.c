
void prints(const char s[])
{
    int i;
    i = 0;
    while (s[i]) {
        putchar((int)s[i++]);
    }
}

int main()
{
    prints("Hello, world!\n");
    return 0;
}
