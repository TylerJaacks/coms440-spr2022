
/*
 * To compile:
 * gcc -Wall wimpy.c -o wimpy
 *
 */

#include <stdio.h>
#include <stdlib.h>

/* Helpers we will need:
 *
 * getNumber() reads a number from stdin and returns it as unsigned
 * nextSymbol() returns next symbol from input stream as char
 * consume(char) consume specified symbol from input stream
 */

char getNumber(unsigned *u, double* d)
{
    // Try unsigned first, or double?
    //
    //
    if (1==scanf("%lf", d)) {
        return 'd';
    }
    if (1==scanf("%u", u)) {
        return 'u';
    }
    fprintf(stderr, "Error, expected number, scanf fail!\n");
    exit(1);
}

int nextSymbol()
{
    for(;;)
    {
        int c = fgetc(stdin);

        /* If whitespace, loop */
        if ( (' ' == c) || ('\t' == c) || ('\r' == c) ) continue;

        ungetc(c, stdin);
        return c;
    }
}

void consume(char c)
{
    int next = fgetc(stdin);
    if (next != c) {
        fprintf(stderr, "Error: expected '%c', got '%c'\n", c, next);
        exit(1);
    }
}

/*

void Product()
{
    unsigned x = getNumber();
    printf("%u ", x);
    while (nextSymbol() == '*')
    {
        consume('*');
        x = getNumber();
        printf("%u * ", x);
    }
}

int Sum()
{
    // printf("postfix: ");
    Product();
    while (nextSymbol() == '+') {
        consume('+');
        Product();
        printf("+ ");
    }
    printf("\n");
    if ('\n' != nextSymbol()) {
        if (feof(stdin)) return 0;
        fprintf(stderr, "Unexpected symbol: '%c'\n", nextSymbol());
        exit(1);
    }
    return 1;
}
*/

int main()
{
    /*
    while (Sum());
    printf("Done\n");
    return 0;
    */

    unsigned u;
    double d;
    char token;

    for (;;)
    {
        token = getNumber(&u, &d);
        printf("Got token '%c' ", token);
        if ('u' == token)   printf(" integer %u\n", u);
        else                printf(" real    %lf\n", d);
    }
    return 0;
}


