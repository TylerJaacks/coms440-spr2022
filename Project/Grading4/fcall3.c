
int func1(int a);

float func2(char b);

void func3(float x);

char func4()
{
  func4();
  func3(3.5);
  func2('1');
  func1(1);
}

void func5(int A[]);

int func6()
{
  int B[50];

  B;

  func5(B);
  func1(3);
  func1(B);
}
