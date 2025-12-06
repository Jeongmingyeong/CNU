import java.util.Scanner;

public class Main {

    // global variable
    static char[] arr = new char[100]; // for store input
    static int cur_index = 0; // 다음에 읽어올 위치
    static char cur_symbol = ' '; // 현재 symbol (자료에서 nextSymbol)


    // return next symbol
    public static char get_Symbol(int cur_index) {
        return arr[cur_index];
    }

    public static void pa() {
        if (cur_symbol == 'a') {
            cur_index++;
            cur_symbol = get_Symbol(cur_index);
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pb() {
        if (cur_symbol == 'b') {
            cur_index++;
            cur_symbol = get_Symbol(cur_index);
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pc() {
        if (cur_symbol == 'c') {
            cur_index++;
            cur_symbol = get_Symbol(cur_index);
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pd() {
        if (cur_symbol == 'd') {
            cur_index++;
            cur_symbol = get_Symbol(cur_index);
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pe() {
        if (cur_symbol == 'e') {
            cur_index++;
            cur_symbol = get_Symbol(cur_index);
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pf() {
        if (cur_symbol == 'f') {
            cur_index++;
            cur_symbol = get_Symbol(cur_index);
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pS() {
        if (cur_symbol == 'a') {
            pa();
            pA();
        } else if (cur_symbol == 'b') {
           pb();
           pB();
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pA() {
        cur_symbol = get_Symbol(cur_index);
        if (cur_symbol == 'a') {
            pa();
            pB();
            pb();
        } else if (cur_symbol == 'b') {
            pb();
            pB();
            pb();
        } else if (cur_symbol == 'c') {
           pc();
           pB();
           pb();
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void pB() {
        cur_symbol = get_Symbol(cur_index);
        if (cur_symbol == 'd') {
            pd();
        } else if (cur_symbol == 'e') {
            pe();
        } else if (cur_symbol == 'f') {
            pf();
        } else {
            // print fail
            System.out.println("FAIL");
            System.exit(1);
        }
    }

    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        // input string (one line)
        String input = sc.nextLine();
        input += "$";
        arr = input.toCharArray();

        // 첫번째 symbol 읽어서 cur_symbol 에 저장
        cur_symbol = get_Symbol(cur_index);
        pS();



        // parsing 을 성공하면 cur_symbol == '$'
        if(cur_symbol == '$') {
            System.out.println("OK");
        } else {
            System.out.println("FAIL");
        }

    }
}
