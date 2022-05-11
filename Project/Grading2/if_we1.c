
#define A 1
#define C 0
#define F f

#ifdef A
1
#else
BAD
#endif

#ifdef B
BAD
BAD
#else
2
3
4
#endif

#ifdef C
5,6,7,8;
#else
NOPE;
BAD(THING);
#endif

#ifdef D
NO
#else
9
#endif

#ifdef E
STILL NO
#else
10;
11;
#endif

#ifdef F
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
