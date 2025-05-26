import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.io.*;

public class Main {
    public static void print_result(String input, String ptn) {
        if (ptn.equals("Phone Number") | ptn.equals("e-mail") | ptn.equals("Phone Type") | ptn.equals("Source File")) {
            System.out.println("Match : The input string is [" + input + "] Matched Type is [" + ptn + "]");
        } else {
            System.out.println("Error : The input does not belong to the given string type [" + input + "]");
        }

    }

    public static void main(String[] args) throws IOException {

        // Write RE of Patterns
        String phone_number = "[0-9]{3}-[0-9]{4}-[0-9]{4}";
        String email = "[a-zA-Z_]+@([a-zA-Z_]+\\.)+[a-zA-Z_]+";
        String phone = "(iPhone |Galaxy )[0-9]{1,3}";
        String file = "[a-zA-Z_]+\\.(c|java|py|ml)";

        // Create an object for each pattern
        Pattern p_phone_number = Pattern.compile(phone_number);
        Pattern p_email = Pattern.compile(email);
        Pattern p_phone = Pattern.compile(phone);
        Pattern p_file = Pattern.compile(file);

        // read input file ( input.txt )
        FileReader reader = new FileReader("./input.txt");
        BufferedReader br = new BufferedReader(reader);

        String s = "";
        // read one line
        while ((s = br.readLine()) != null) {
            // phone number 와 match 되는지 확인
            if(p_phone_number.matcher(s).matches()) {
                print_result(s, "Phone Number");
            }

            // check s matches email
            else if (p_email.matcher(s).matches()) {
                print_result(s, "e-mail");
            }

            // check s matches phone type
            else if (p_phone.matcher(s).matches()) {
                print_result(s, "Phone Type");
            }

            // check s matches source file
            else if (p_file.matcher(s).matches()) {
                print_result(s, "Source File");
            }

            // check s does not match anything
            else {
                print_result(s, "Nothing");
            }
        }
    }
}