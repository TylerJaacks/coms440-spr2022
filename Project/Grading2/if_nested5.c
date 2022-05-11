
#define A a
#define E e

1
#ifdef A
2
#ifndef B
3
#ifndef C
4
#ifndef D
5
#ifdef E
6
#else
BAD
#endif // E
7
#else
BAD
#endif // D
8
#endif // C
9
#else
BAD
#endif // B
10
#endif // A
11
