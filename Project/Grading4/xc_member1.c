
struct stack {
  int data[100];
  int top;
};

struct stack S;

void test()
{
  S;
  S.top;
  S.data;
  S.data[5];
}

void push(int x)
{
  // Should check for stack overflow
  S.data[S.top++] = x;
}

int pop()
{
  // Should check for stack underflow
  return S.data[--S.top];
}
