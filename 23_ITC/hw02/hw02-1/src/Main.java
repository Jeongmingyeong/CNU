import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.*;
import tinyPython.tinyPythonLexer;
import tinyPython.tinyPythonParser;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        tinyPythonLexer lexer = new tinyPythonLexer(CharStreams.fromFileName("test.tpy"));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        tinyPythonParser parser = new tinyPythonParser(tokens);
        ParseTree tree = parser.program();
    }
}