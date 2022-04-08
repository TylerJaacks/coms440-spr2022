
class float1 {

  public static int[] A = new int[50];

  public static int checkfloat() {
    int count = 0;
    float f = 1.0f;
    f += count;
    while (f>0) {
      f /= 2.0f;
      ++count;
    }
    return count;
  }

  public static void main(String args[]) {
    System.out.print("Float divisions to zero: ");
    System.out.println(checkfloat());
  }
}


