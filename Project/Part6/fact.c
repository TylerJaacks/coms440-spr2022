
void print2(int x)
{
    if (x>9) {
        putchar(48 + x/10);
    } else {
        putchar(32);
    }
    putchar(48 + x%10);
}

void printi(int i)
{
    int d, digits[30];

    if (i<0) {
        putchar(45);
    }

    d = 0;
    do {
        digits[d] = i % 10;
        if (digits[d]<0) {
            digits[d] = 48 - digits[d];
        } else {
            digits[d] += 48;
        }
        i /= 10;
        d++;
    } while (i);

    while (d) {
        putchar(digits[--d]);
        if ((d>0) && (0 == d %3)) putchar(44);
    }
}

int main()
{
    int i, f;
    f = 1;
    for (i=1; i<13; i++) {
        print2(i);
        putchar(33);
        putchar(32);
        putchar(61);
        putchar(32);
        printi(f *= i);
        putchar(10);
    }
    return 0;
}
