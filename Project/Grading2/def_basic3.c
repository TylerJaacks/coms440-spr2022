
#define MESSAGE "Hello, stupid world!"
#define PATH "/usr/local/share/test.txt"

#define BYTES 1024

#define NEWLINE '\n'

#define BARF    fprintf(stderr. "An unexpected error has occurred.\n")

#define EMPTY

int main()
{
    printf(MESSAGE);
    char buffer[BYTES];
    fputc(NEWLINE, stdout);
    BARF;
    fopen(PATH, "r");
    20 EMPTY ;
}
