class Animal {
    void makeSound() {
        System.out.println("Some sound");
    }
}

class Dog extends Animal {
    void makeSound() {
        System.out.println("Bark");
    }

    void go() {
        System.out.println("walk");
    }
}

public class Main {
    public static void main(String[] args) {
        Animal myAnimal = new Animal();
        Animal myDog = new Dog(); // Dog is a subtype of Animal
        myAnimal.makeSound(); // "Some sound"
        myDog.makeSound(); // "Bark"
//        myDog.go(); // error

        Dog realDog = new Dog();
        realDog.go();
    }
}



//import org.antlr.v4.runtime.CharStreams;
//import org.antlr.v4.runtime.CommonTokenStream;
//import org.antlr.v4.runtime.tree.ParseTree;
//import org.antlr.v4.runtime.tree.ParseTreeWalker;
//
//import java.io.IOException;
//
//public class Main {
//    public static void main(String[] args) throws IOException {
//        tinyPythonLexer lexer = new tinyPythonLexer(CharStreams.fromFileName("Test.tpy"));
//        CommonTokenStream tokens = new CommonTokenStream( lexer );
//        tinyPythonParser parser = new tinyPythonParser ( tokens );
//        ParseTree tree = parser.program();
//
//        ParseTreeWalker walker = new ParseTreeWalker();
//        walker.walk(new tinyPythonCompilerListener(), tree);
//    }
//}
