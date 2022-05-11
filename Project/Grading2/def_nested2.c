
#define MESSAGE "Hello, world!\n"
#define GREET   printf(MESSAGE)

#define NEWLINE \n
#define NOT nope nope nope nope
#define TRICKY  "Should NOT be replaced NEWLINE"

int main()
{
    GREET;

    printf(TRICKY);
}
