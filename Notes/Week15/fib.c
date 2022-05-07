
#include <stdio.h>

const unsigned size = 14;
long F[size];

int main()
{
    unsigned i;
    F[0] = 0;
    F[1] = 1;
    for (i=2; i<size; i++) {
        F[i] = F[i-1] + F[i-2];
    }
    printf("Fib(%u) = %ld\n", size-1, F[size-1]);
    return 0;
}

