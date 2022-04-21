
#define PI  3.1415926

float area(float radius)
{
    return PI*radius*radius;
}

#define PAIR    struct pair

int test()
{
    PAIR p;
}

PAIR

#undef PAIR

char test2()
{
    PAIR p;
}

#define ONE     1
#define TWO     ONE+1
#define THREE   TWO+1
#define FOUR    THREE+1
#define FIVE    FOUR+1

int five = FIVE;
