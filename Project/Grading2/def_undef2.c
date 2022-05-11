
#define STRMAX 1024
#define INTMAX 48

char strbuf[STRMAX];
char intbuf[INTMAX];

#undef INTMAX

struct limits {
    int INTMAX;
    int STRMAX;
};

#define INTMAX 1000

INTMAX

#undef INTMAX

INTMAX

#define INTMAX "intmax"

INTMAX

#undef INTMAX

INTMAX
