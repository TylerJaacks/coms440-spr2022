
int myfunc(int a)
{
  a;
}

int myfunc(int b);    /* OK */

void filler();
void functions();

int myfunc(int a) { /* Can't define a function twice */ }

