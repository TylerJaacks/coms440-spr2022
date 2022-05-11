
#define A a

#ifdef A
#define C c
1
#else
#define B b
BAD
#endif

#ifdef B
BAD
#else
2
#endif

#ifdef C
3
#else
BAD
#endif

4
5
