
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

unsigned getNumber()
{
    unsigned x;
    if (0==scanf("%u", &x)) {
        fprintf(stderr, "Error: expected integer\n");
        exit(1);
    }
    if (feof(stdin)) {
        fprintf(stderr, "End of input\n");
        exit(0);
    }
    return x;
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

int main()
{
    while (Sum());
    printf("Done\n");
    return 0;
}


