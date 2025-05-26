public class Test {
    public Test() {
        super();
    }

    public static int add(int a, int b) {
        int result = a + b;
        return result;
    }

    public static void main(String[] args) {
        int a = 33;
        System.out.println(add(a, 1));
    }
}
