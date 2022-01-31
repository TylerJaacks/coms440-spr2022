
#include <stdio.h>
#include <stdlib.h>

/******/

/**/



void skip_ws()
{
    for(;;) {
        int c = fgetc(stdin);
        if (' ' == c) continue;
        if ('\t' == c) continue;
        if ('\r' == c) continue;
        if ('\n' == c) continue;

        ungetc(c, stdin);
        return;
    }
}

char getNumber(unsigned *u, double *d)
{
    skip_ws();
    char saw_dot = 0;
    char lexeme[100];
    for (unsigned p=0; p<100; p++) {
        int c = fgetc(stdin);   // consume the char
        lexeme[p] = c;  // add to the lexeme
        if (('0' <= c) && (c <= '9')) {
            /* Still a digit */
            continue;
        }
        if ('.' == c) {
            if (0==saw_dot) {
                saw_dot++;
                continue;
            }
        }
        //
        // Here?  Not a digit, not a ., or second .
        //
        ungetc(c, stdin);
        lexeme[p] = 0;
        if (0==p) {
            fprintf(stderr, "Error, expected a number!\n");
            exit(1);
        }

        if (saw_dot) {
            *d = atof(lexeme);  /* convert lexeme to double */
            return 'd';
        } else {
            *u = atol(lexeme);  /* convert lexeme to unsigned */
            return 'u';
        }

    }
    fprintf(stderr, "Error, number too long!\n");
    exit(1);
    return 0;
}

int main()
{
    char c;
    unsigned u;
    double d;

    while (!feof(stdin)) {
        c = getNumber(&u, &d);
        if ('u' == c) {
            printf("Got unsigned: %u\n", u);
        } else {
            printf("Got double  : %lf\n", d);
        }
    }
    printf("End of input\n");
    return 0;
}
