import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTreeProperty;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.io.FileWriter;
import java.io.IOException;
import java.util.Optional;

public class tinyPythonCompilerListener extends tinyPythonBaseListener {
    ParseTreeProperty<String> result = new ParseTreeProperty<>();
    static SymbolTable symbolTable = new SymbolTable();

    @Override
    public void enterProgram(tinyPythonParser.ProgramContext ctx) {
        symbolTable.initFuntable();
    }

    // class declaration code
    static String getClassCode() {
        return (".class public Test\n"
                + ".super java/lang/Object\n"
                + ".method public <init>()V\n"
                + "aload_0\n"
                + "invokenonvirtual java/lang/Object/<init>()V\n"
                + "return\n"
                + ".end method\n\n");
    }
    @Override
    public void exitProgram(tinyPythonParser.ProgramContext ctx) {
        String class_code = getClassCode();
        String program = result.get(ctx.file_input());

        try {
            // create writer object
            FileWriter writer = new FileWriter("./Test.j");

            // append result to writer object
            writer.append(class_code + program + "return\n" + ".end method\n");

            // create "Test.j" file
            writer.flush();

        } catch (IOException e) { // handling IOException
            System.out.println("can't find file");
            System.exit(1);
        }

    }



    @Override
    public void exitFile_input(tinyPythonParser.File_inputContext ctx) {
        int idx_newline = 0;
        int idx_stmt = 0;

        // step1. handled "defs"
        String str = result.get(ctx.defs());

        // handled  [ (NEWLINE | stmt)* EOF ]
        // step2. handled front list and then handled EOF
        for(int i = 1; i < ctx.getChildCount()-1; i++) { // because EOF is handled separately
            // case1 : NEWLINE
            if(ctx.getChild(i) == ctx.NEWLINE(idx_newline)) {
                str += ctx.NEWLINE(idx_newline++);
            }

            // case2 : stmt
            else {
                str += result.get(ctx.stmt(idx_stmt++));
            }
        }

        // handled EOF : nothing

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitDefs(tinyPythonParser.DefsContext ctx) {
        String str = "";

        // handling def_stmt*
        int def_idx = 0;
        int idx_newline = 0;
        for(int i = 0; i < ctx.getChildCount(); i++) {

            if(ctx.getChild(i) != null) {
                // case1 : NEWLINE
                if(ctx.getChild(i) == ctx.NEWLINE(idx_newline)) {
                    str += "\n";
                    idx_newline++;
                }

                // case2 : def_stmt
                else {
                    str += result.get(ctx.def_stmt(def_idx++));
                }
            }
        }

        String main_header =
                ".method public static " + symbolTable.getFuncSigniture("main") + "\n"
                        + ".limit stack 32" + "\n"
                        + ".limit locals 32" + "\n";

        result.put(ctx, str + main_header);
    }


    @Override
    public void exitStmt(tinyPythonParser.StmtContext ctx) {
        // add indentation before all stmt (both simple, compound stmt)
        String str = "";

        // case1 : simple_stmt
        if(ctx.simple_stmt() != null) {
            str = result.get(ctx.simple_stmt());
        }

        // case2 : compound_stmt
        else {
            str = result.get(ctx.compound_stmt());
        }

        // store string into result tree
        result.put(ctx, str);
    }


    @Override
    public void exitSimple_stmt(tinyPythonParser.Simple_stmtContext ctx) {
        String str = "";

        // handled [ small_stmt NEWLINE ]
        if(ctx.small_stmt() != null) {
            str = result.get(ctx.small_stmt());
            str += ctx.NEWLINE().getText();
        }

        // store string into result tree
        result.put(ctx, str);
    }


    @Override
    public void exitSmall_stmt(tinyPythonParser.Small_stmtContext ctx) {
        String str = "";

        // handled 4 cases in small_stmt

        // case1 : assignment_stmt
        if (ctx.assignment_stmt() != null) {
            str = result.get(ctx.assignment_stmt());
        }

        // case2 : flow_stmt
        else if (ctx.flow_stmt() != null) {
            str = result.get(ctx.flow_stmt());
        }

        // case3 : print_stmt
        else if (ctx.print_stmt() != null) {
            str = result.get(ctx.print_stmt());
        }

        // case4 : return_stmt
        else {
            str = result.get(ctx.return_stmt());
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitAssignment_stmt(tinyPythonParser.Assignment_stmtContext ctx) {
        // handled [ NAME '=' expr ]
        String var_name = ctx.NAME().getText(); // variable name
        String expr_value = result.get(ctx.expr());

        symbolTable.putVar(var_name, expr_value);

        // generate JVM code
        String str = expr_value + "\n";
        str += "istore " + symbolTable.getVarID(var_name);

        // store string into result tree
        result.put(ctx, str);

        // insert var into vartable
//        symbolTable.putVar(var_name, "INT", expr_value);
    }

    @Override
    public void exitFlow_stmt(tinyPythonParser.Flow_stmtContext ctx) {
        String str = "";

        // handled 2 cases
        // case1 : break_stmt
        if(ctx.break_stmt() != null) {
            str = result.get(ctx.break_stmt());
        }

        // case2 : continue_stmt
        else {
            str = result.get(ctx.continue_stmt());
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitBreak_stmt(tinyPythonParser.Break_stmtContext ctx) {
        // store "break" string into result tree
        result.put(ctx, "goto");
    }

    @Override
    public void exitContinue_stmt(tinyPythonParser.Continue_stmtContext ctx) {
        // store "continue" string into result tree
        result.put(ctx, "goto");
    }
    
    @Override
    public void exitCompound_stmt(tinyPythonParser.Compound_stmtContext ctx) {
        String str = "";

        // handled 3 cases
        // case1 : if_stmt
        if(ctx.if_stmt() != null) {
            str = result.get(ctx.if_stmt());
        }

        // case2 : while_stmt
        else if(ctx.while_stmt() != null) {
            str = result.get(ctx.while_stmt());
        }

        // store string into result tree
        result.put(ctx, str);
    }


    @Override
    public void exitIf_stmt(tinyPythonParser.If_stmtContext ctx) {
        String str = "";

        int cond_idx = 0;
        int body_idx = 0;
        String if_cond = result.get(ctx.test(cond_idx));
        String if_body= result.get(ctx.suite(body_idx));

        String lend = symbolTable.newLabelID();

        // check exists "elif" or "else
        if(ctx.getChildCount() < 5) {
            // only exist if_stmt
            str += if_cond + lend + "\n"
                    + if_body + "\n";

        }

        // check exist "else" stmt with only "if" stmt
        else if (ctx.getChildCount() == 7) {
            // exist "else" stmt with only "if" stmt
            String lelse = symbolTable.newLabelID();
            String else_body = result.get(ctx.suite(++body_idx));

            str += if_cond + lelse + "\n"
                    + if_body + "\n"
                    + lelse + ": " + "\n" + else_body + "\n";
        }

        // only "elif" exist without "else"
        else if (ctx.getChildCount() % 4 == 0) {
            // at least one "elif" exist
            String lelif = symbolTable.newLabelID();

            str += if_cond + lelif + "\n"
                    + if_body + "\n";

            int index = 4;

            while((ctx.getChildCount() - index > 0)) {
                // exist another "elif"
                String elif_cond = result.get(ctx.test(++cond_idx));
                String elif_body = result.get(ctx.suite(++body_idx));

                str += lelif + ": " + elif_cond;

                lelif = symbolTable.newLabelID(); // create new elif label

                str += lelif + "\n"
                        + elif_body + "\n";

                index += 4;
            }

            String elif_cond = result.get(ctx.test(++cond_idx));
            String elif_body = result.get(ctx.suite(++body_idx));
            str += lelif + ": " + elif_cond + lend + "\n"
                    + elif_body + "\n";
        }

        // exist "elif" and "else"
        else {
            String lelif = symbolTable.newLabelID();

            str += if_cond + lelif + "\n"
                    + if_body;

            int index = 4;

            while((ctx.getChildCount() - (index * 2) > 0)) {
                // exist another "elif"
                String elif_cond = result.get(ctx.test(++cond_idx));
                String elif_body = result.get(ctx.suite(++body_idx));

                str += lelif + ": " + "\n" + elif_cond;

                lelif = symbolTable.newLabelID(); // create new elif label

                str += lelif + "\n"
                        + elif_body;

                index += 4;
            }

            // this part is "else" stmt
//            String elif_cond = result.get(ctx.test(++cond_idx));

            String else_body = result.get(ctx.suite(++body_idx));

            String lelse = lelif;

            str += lelse + ": " + "\n" + else_body + "\n";
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitWhile_stmt(tinyPythonParser.While_stmtContext ctx) {
        String str = "";

        String cond = result.get(ctx.test());
        String body = result.get(ctx.suite());

        String lloop = symbolTable.newLabelID(); // for "Loop:" label
        String lloopend = symbolTable.newLabelID(); // for "LoopEnd:" label

        // step1. check condition code
        // step2. execute body and goto loop
        str += lloop + ": " + "\n"
                + cond + lloopend + "\n"
                + body
                + "goto " + lloop + "\n"
                + lloopend + ": " + "\n";

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void enterDef_stmt(tinyPythonParser.Def_stmtContext ctx) {
        symbolTable.initFunDecl();

        symbolTable.putFuncSigniture(ctx);

    }

    private static String getFuncHeader(tinyPythonParser.Def_stmtContext ctx, String func_name) {
        // FIXME :
        String func_header =
                ".method public static " + symbolTable.getFuncSigniture(func_name) + "\n"
                + ".limit stack 32" + "\n"
                + ".limit locals 32" + "\n";
        return func_header;
    }

    @Override
    public void exitDef_stmt(tinyPythonParser.Def_stmtContext ctx) {
        String fname = ctx.NAME().getText(); // function name
        String fheader = getFuncHeader(ctx, fname);
        String fsuite = result.get(ctx.suite());
        String ffooter = ".end method" + "\n";

        String str = fheader + fsuite + ffooter;

        // store string into result tree
        result.put(ctx, str);
    }


    @Override
    public void exitSuite(tinyPythonParser.SuiteContext ctx) {
        String str = "";

        // handled 2 cases

        // case1 : simple_stmt
        if( ctx.simple_stmt() != null) {
            str += result.get(ctx.simple_stmt());
        }

        // case2 : NEWLINE stmt+ : ignore NEWLINE for indentation
        else {
            for(int i = 0; i < ctx.stmt().size(); i++) {
                if(result.get(ctx.stmt(i)) != null) {
                    str += result.get(ctx.stmt(i));
                }
            }
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitArgs(tinyPythonParser.ArgsContext ctx) {
        String str = "";

        // handled 2 cases
        // case1 : [ NAME ("," NAME)* ]
        if(ctx.getChildCount() >= 1) {
            symbolTable.putVar(ctx.NAME(0).getText(), "args");
            for(int i = 1; i < (ctx.getChildCount()/2 + 1); i++) { // except ","
                symbolTable.putVar(ctx.NAME(i).getText(), "args");
            }
        }

        // case2 : whitespace (공백)
        else {
            str = "";
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitReturn_stmt(tinyPythonParser.Return_stmtContext ctx) {
        // handled [ 'return' ] or [ 'return' expr ]
        String str = "";

        // case: return expr
        if(ctx.expr() != null) {
            String temp = result.get(ctx.expr());
            str += temp + "\n";
            str += "ireturn";
        }

        // case: return
        else {
            str += "return";
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitTest(tinyPythonParser.TestContext ctx) {
        String str = result.get(ctx.expr(0)) + "\n";
        str += result.get(ctx.expr(1)) + "\n";
        str += result.get(ctx.comp_op());

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitPrint_stmt(tinyPythonParser.Print_stmtContext ctx) {
        String str = "getstatic java/lang/System/out Ljava/io/PrintStream;" + "\n";
        str += result.get(ctx.print_arg()) + "\n";

        // case1. print arg == string
        if(ctx.print_arg().STRING() != null) {
            str += "invokevirtual " + symbolTable.getFuncSigniture("print_S");
        }

        // case2. print arg == expr
        else {
            str += "invokevirtual " + symbolTable.getFuncSigniture("print_I");
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitPrint_arg(tinyPythonParser.Print_argContext ctx) {
        // handled 2 cases
        // case1 : STRING
        if(ctx.STRING() != null) {
            String temp = "ldc " + ctx.STRING().getText();
            result.put(ctx, temp);
        }

        // case2 : expr
        else {
            result.put(ctx, result.get(ctx.expr()));
        }
    }

    @Override
    public void exitComp_op(tinyPythonParser.Comp_opContext ctx) {
        // handled 6 cases with whitespace
        // case1 : "<"
        if(ctx.getChild(0).getText().equals("<")) {
            result.put(ctx, "if_icmpge ");
        }

        // case2 : ">"
        else if(ctx.getChild(0).getText().equals(">")) {
            result.put(ctx, "if_icmple ");
        }

        // case3 : "=="
        else if(ctx.getChild(0).getText().equals("==")) {
            result.put(ctx, "if_icmpne ");
        }

        // case4 : ">="
        else if(ctx.getChild(0).getText().equals(">=")) {
            result.put(ctx, "if_icmplt ");
        }

        // case5 : "<="
        else if(ctx.getChild(0).getText().equals("<=")) {
            result.put(ctx, "if_icmpgt ");
        }

        // case6 : "!="
        else {
            result.put(ctx, "if_icmpeq ");
        }
    }

    @Override
    public void exitExpr(tinyPythonParser.ExprContext ctx) {
        String str = "";

        // handled 4 cases
        // case1 : [ NAME opt_paren ] is getchildCount == 2 <- function call
        if(ctx.getChildCount() == 2) {
            String value = ctx.NAME().getText();

            // case1. opt_paren() == null => NAME is var name
            if(result.get(ctx.opt_paren()).equals("")) {
                str += "iload " + symbolTable.getVarID(value);
            }

            // case2. opt_paren() != null => function call
            else {
                str += result.get(ctx.opt_paren());
                str += "Test/" + symbolTable.getFuncSigniture(value);
            }
        }

        // case2 : [ NUMBER ] is getchildCount == 1 <- integer value
        else if(ctx.getChildCount() == 1) {
            String value = ctx.NUMBER().getText();
            str += "ldc " + value;
        }

        // case3 : [ '(' expr ')' ] is getchildCount == 3
        // case4 : [ expr (('+' | '-') expr)+ ] is also getchildCount == 3
        // case3 and 4 is distinct by getchild(1) == operator or expr
        else {
            // case4 : binary operation
            if(ctx.getChild(1).getText().equals("+") | ctx.getChild(1).getText().equals("-")) {
                int op_idx = 1;
                int expr_idx = 0;
                String expr1 = result.get(ctx.expr(expr_idx));
                String expr2 = "";

                while(ctx.getChild(op_idx) != null) {
                    if(ctx.getChild(op_idx).getText().equals("+")) {
                        // op is "+"
                        expr2 = result.get(ctx.expr(++expr_idx));

                        str += expr1 + "\n";
                        str += expr2 + "\n";
                        str += "iadd";

                        op_idx += 2;
                    }

                    else if(ctx.getChild(op_idx).getText().equals("-")) {
                        // op is "-"
                        expr2 = result.get(ctx.expr(++expr_idx));

                        str += expr1 + "\n";
                        str += expr2 + "\n";
                        str += "isub";

                        op_idx += 2;
                    }

                    else {
                        break;
                    }
                }
            }

            // case3
            else {
                str = result.get(ctx.expr(0));
            }
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitOpt_paren(tinyPythonParser.Opt_parenContext ctx) {
        String str = "";

        // handled 3 cases
        // case1 : [ '(' ')' ] is getchildCount == 2
        if(ctx.getChildCount() == 2) {
            str = "invokestatic ";
        }

        // case2 : [ '(' expr (',' expr)* ')' ]
        else if(ctx.getChildCount() >= 3) {
            str = result.get(ctx.expr(0));
            int index = 1;

            for(int i = 2; i < ctx.getChildCount()-1; i+=2) {
                str += "\n" + result.get(ctx.expr(index));
                index++;
            }

            str += "\ninvokestatic ";
        }

        // case3 : whitespace (공백)
        else {
            str = "";
        }

        // store string into result tree
        result.put(ctx, str);
    }
}
