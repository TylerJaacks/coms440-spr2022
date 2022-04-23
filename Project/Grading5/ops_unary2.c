
//
// More negation tests
//

void dummy1(char a);
void dummy2(int b);
void dummy3(float c);

void test()
{
  dummy1( -('A') );
  dummy2( -(3)   );
  dummy3( -(4.5) );
  return;
}
