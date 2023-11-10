public class Main {

    public static int sum(int n) {
      int result = 0;
      int i = 1;

      while (i <= n) {
        result += i;
        i++;
      }

      return result;
    }

    public static void main(String[] args) {
      int n = 100;
      System.out.println(sum(n));
    }
}
