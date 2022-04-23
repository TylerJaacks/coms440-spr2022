
//
// Type conversions
//

void dummy1(int a);
void dummy2(float a);

void toint()
{
  dummy1( (int) 'A' );
  dummy1( (int) 44  );
  dummy1( (int) 4.8 );
  return;
}

void tofloat()
{
  dummy2( (float) 44  );
  return;
}
