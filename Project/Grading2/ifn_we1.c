
#define A 1
#define B 0
#define D "thing"
#define E 2.718

#ifndef A
BAD
#else
1
#endif

#ifndef B
BAD
BAD
#else
2
3
4
#endif

#ifndef C
5,6,7,8;
#else
NOPE;
BAD(THING);
#endif

#ifndef D
NO
#else
9
#endif

#ifndef E
STILL NO
#else
10;
11;
#endif

#ifndef F
12;
/* comment */
13;

// #else bwahahaha

14;
15;
#else

SHOULD BE OFF!

#endif

16;
