import java.io.*;
import java.util.Stack;

// [Task 01] Additional implementation
// 변수간의 연산 수행
// ex) 식어 어어 어 어어! ==> printf("%d\n", a * aa * a * aa);

public class Main {
    public static void main(String[] args) throws IOException {

        // 엄랭 file (test.umm) 읽어오는 객체 생성
        FileReader reader = new FileReader("./src/test.umm");
        BufferedReader br = new BufferedReader(reader);

        // c file (test.c) 에 작성하는 객체 생성
        FileWriter writer = new FileWriter("./src/test.c");

        // 처리하면서 사용할 변수 선언
        String s = "";
        int count = 0; // 어의 개수 (변수의 index)
        int value = 0; // . 과 , 을 계산하기 위한 변수, default = 0
        String name = "a"; // 변수 default name
        Stack<Integer> stack = new Stack<>(); // 곱하기를 만날때마다 숫자를 저장해주고 마지막 출력 또는 할당 시 꺼내서 곱하기 계산
        boolean flag_um = false;    // flag for 엄


        // 한줄씩 읽어오기
        while ((s = br.readLine()) != null) {
            System.out.println(s);

            // 변수 초기화
            count = 0;
            value = 0;
            stack.clear();
            flag_um = false;

            switch (s) {
                case "어떻게": // start
                    writer.append("#include <stdio.h>\n\n");
                    writer.append("int main() {\n");
                    writer.append("\tint a = 0, aa = 0, aaa = 0;\n\n");
                    break;

                case "이 사람이름이냐ㅋㅋ": // finish
                    writer.append("\n\treturn 0;\n");
                    writer.append("}\n");
                    break;

                default: // other keyword
                    char[] carr = s.toCharArray();
                    for (int i = 0; i < carr.length; i++) {
                        switch (carr[i]) {
                            case '어':
                                count++;

                                // 앞에 엄이 없을 때
                                if (!flag_um) {
                                    // 뒤에 '!' 가 온다면 print 문 안에 변수 write
                                    if (i <= carr.length - 1) {
                                        if ((carr[i + 1] == '!') || (carr[i + 1] == 'ㅋ') || (carr[i + 1] == ' ') || (i == carr.length - 1)) {
                                            String va_name = name.repeat(count);
                                            writer.append(va_name);
                                            count = 0;
                                            break;
                                        }
                                    }
                                }

                                // 앞에 엄이 있다면 뒤의 어는 load 임. ( 앞에 엄이 없다면 그냥 index 만 1 증가 )
                                if (flag_um) {
                                    if (i < carr.length - 1) {
                                        if (carr[i + 1] == ' ') {
                                            System.out.println("into a + \" \"");
                                            String va_name = name.repeat(count);
                                            writer.append(va_name + " * ");
                                            count = 0;
                                            break;
                                        } else if (carr[i + 1] == '.') {
                                            String va_name = name.repeat(count);
                                            writer.append(va_name + " + ");
                                            count = 0;
                                            break;
                                        } else if (carr[i + 1] == ',') {
                                            String va_name = name.repeat(count);
                                            writer.append(va_name);
                                            count = 0;
                                            break;
                                        }
                                    } else { // 어가 현재 라인의 가장 마지막 character 일때
                                        String va_name = name.repeat(count);
                                        writer.append(va_name);
                                        count = 0;
                                        break;
                                    }
                                }

                                break;

                            case '엄':
                                flag_um = true;
                                count ++;
                                String vname = name.repeat(count);

                                if (i <= carr.length - 1) {
                                    // 엄 뒤에 식이 아니라면 즉, {어, '.', ',',} 라면
                                    if ((carr[i + 1] != '식') || (i == carr.length - 1)) {
                                        writer.append("\t" + vname + " = ");
                                        count = 0;
                                    }
                                }
                                break;

                            case '식':
                                if(i == 0) { // 무조건 print 이다. 즉, 가장 마지막에 나오는 ! or ㅋ 사이의 값 출력
                                    switch(carr[carr.length-1]) {
                                        case '!':
                                            writer.append("\tprintf(\"%d\\n\", ");
                                            break;
                                        case 'ㅋ':
                                            writer.append("\tprintf(\"%c\\n\", ");
                                            break;
                                    }
                                }
                                else { // 입력받는 경우 (식? 인 경우)
                                    String v_name = name.repeat(count);
                                    writer.append("\tscanf(\"%d\\n\", &" + v_name + ")");
                                    count = 0;
                                }
                                break;

                            case '.':
                                value ++;

                                if (i < carr.length - 1) {
                                    if (carr[i+1] == ' '){ // 뒤에 ' '(공백) 이 나오면 현재까지의 value stack 에 저장
                                        stack.push(value);
                                        value = 0;
                                    }
                                } else if (i == carr.length - 1) {
                                    int calc_value = value;

                                    while(!stack.empty()) { // stack 에 있는 모든 값 곱해서 계산
                                        calc_value *= stack.pop();
                                    }

                                    writer.append(Integer.toString(calc_value));
                                    value = 0;
                                }
                                break;

                            case ',':
                                value --;

                                if (i == carr.length - 1) {
                                    int calc_value = value;

                                    while(!stack.empty()) { // stack 에 있는 모든 값 곱해서 계산
                                        calc_value *= stack.pop();
                                    }

                                    writer.append(Integer.toString(calc_value));
                                    value = 0;
                                }
                                break;

                            case ' ':
                                // 앞에 엄이 있을 때는 위에서 cover 해줬으니 여기서는 엄이 없을 때만
                                if(!flag_um) {

                                    // 공백 앞이나 뒤에 변수가 ('어') 있을 땐 * append
                                    if(carr[i-1] == '어') { // 앞에 '어'가 있으면 '*' 만 append

                                        writer.append(" * ");

                                    } else if(carr[i+1] == '어') {

                                        if(!stack.empty()) { // stack 에 값이 있으면 안에 값들 다 곱한 후 출력
                                            int calc_value = value;

                                            while(!stack.empty()) { // stack 에 있는 모든 값 곱해서 계산
                                                calc_value *= stack.pop();
                                            }

                                            writer.append(Integer.toString(calc_value) + " * ");
                                        } else { // stack 이 비어있다면 value 가 0인지 확인해서 0이면 pass, 0이 아니면 (value *) append
                                            if(value != 0) {
                                                writer.append(" " + Integer.toString(value) + " * ");
                                            }
                                        }

                                        value = 0;
                                    }
                                }
                                break;

                            case '!': case 'ㅋ':
                                if(value != 0) { // 어떤 값이 있어서 반영해야할 때
                                    if(!stack.empty()) { // stack 안에도 값이 있을 때 -> 계산해줘야함.
                                        int calc_value = value;

                                        while(!stack.empty()) { // stack 에 있는 모든 값 곱해서 계산
                                            calc_value *= stack.pop();
                                        }

                                        writer.append(Integer.toString(calc_value));
                                    } else {
                                        writer.append(Integer.toString(value));
                                    }
                                }

                                writer.append(")");
                                value = 0;
                                break;

                            default: // ignore other character
                                break;
                        }
                    }

                    // line 에 뭐가 하나라도 있을 때만 마지막에 세미콜론 찍기
                    if(carr.length != 0) {
                        writer.append(";\n");
                    }
                    break;
            }
        }

        writer.flush();
        writer.close();

    }
}
