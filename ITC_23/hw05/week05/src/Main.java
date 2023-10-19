import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.antlr.v4.runtime.tree.ParseTree;

import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException {
        tinyPythonLexer lexer = new tinyPythonLexer(CharStreams.fromFileName("nested_ifelse.tpy"));
        CommonTokenStream tokens = new CommonTokenStream( lexer );
        tinyPythonParser parser = new tinyPythonParser ( tokens );
        ParseTree tree = parser.program();

        ParseTreeWalker walker = new ParseTreeWalker();
        walker.walk(new tinyPythonPrintListener(), tree);
    }
}
