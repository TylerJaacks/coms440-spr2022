import java.io.IOException;

class libc {
  public static int putchar(int c) {
    System.out.print((char) c);
    return c;
  }
  public static int getchar() throws IOException {
    return System.in.read();
  }
};
