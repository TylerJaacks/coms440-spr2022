
int moreloops(int really)
{
  int x;

  x = 3;

  do {
    x++;
    while (x%3) {
      x++;
    }
    x--;
    do 
    {
      /* This is legal */
    }
    while (x++);
  } while (x<5);  

  x = 4;
}
