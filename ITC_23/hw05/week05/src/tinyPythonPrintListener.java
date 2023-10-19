import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTreeProperty;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.util.Optional;

public class tinyPythonPrintListener extends tinyPythonBaseListener {
    ParseTreeProperty<String> result = new ParseTreeProperty<>();
    int num_indent = 0; // use for check indent
    int else_indent = 0; // use for check "else" or "elif" indent

    // Use for add an indentation
    public String indent_string(int number) {
        return " ".repeat(number*4);
    }

    @Override
    public void exitProgram(tinyPythonParser.ProgramContext ctx) {

        // handled file_input case
        String program = result.get(ctx.file_input());

        // print all program
        System.out.println(program);
    }

    @Override
    public void exitFile_input(tinyPythonParser.File_inputContext ctx) {
        String str = "";
        int idx_newline = 0;
        int idx_stmt = 0;

        // handled  [ (NEWLINE | stmt)* EOF ]
        // first, handled front list and then handled EOF
        for(int i = 0; i < ctx.getChildCount()-1; i++) { // because EOF is handled separately
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
    public void exitStmt(tinyPythonParser.StmtContext ctx) {
        // add indentation before all stmt (both simple, compound stmt)
        String str = null;

        // case1 : simple_stmt
        if(ctx.simple_stmt() != null) {
            str = indent_string(num_indent) + result.get(ctx.simple_stmt());
        }

        // case2 : compound_stmt
        else {
            str = indent_string(num_indent) + result.get(ctx.compound_stmt());
        }

        // store string into result tree
        result.put(ctx, str);
    }


    @Override
    public void exitSimple_stmt(tinyPythonParser.Simple_stmtContext ctx) {
        String str = null;

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
        String str = null;

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
        String str = null;

        // handled [ NAME '=' expr ]
        // first, add NAME to str
        str = ctx.NAME().getText();

        // second, add '=' to str with whitespace
        str += " = ";

        // finally, get expr result
        str += result.get(ctx.expr());

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitFlow_stmt(tinyPythonParser.Flow_stmtContext ctx) {
        String str = null;

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
        result.put(ctx, "break");
	}

    @Override
    public void exitContinue_stmt(tinyPythonParser.Continue_stmtContext ctx) {
        // store "continue" string into result tree
        result.put(ctx, "continue");
    }

    @Override
    public void enterCompound_stmt(tinyPythonParser.Compound_stmtContext ctx) {}
    @Override
    public void exitCompound_stmt(tinyPythonParser.Compound_stmtContext ctx) {
        String str = null;

        // handled 3 cases
        // case1 : if_stmt
        if(ctx.if_stmt() != null) {
            str = result.get(ctx.if_stmt());
        }

        // case2 : while_stmt
        else if(ctx.while_stmt() != null) {
            str = result.get(ctx.while_stmt());
        }

        // case3 : def_stmt
        else {
            str = result.get(ctx.def_stmt());
        }

        // store string into result tree
        result.put(ctx, str);
    }

    // todo:
    @Override
    public void exitIf_stmt(tinyPythonParser.If_stmtContext ctx) {
        int idx_test = 0;
        int idx_suite = 0;
        int if_indent_level = 0;
        System.out.println("if_child_count: " + ctx.getChildCount());

        String str = "if " + result.get(ctx.test(idx_test++)) + ":";
        str += "\n" + result.get(ctx.suite(idx_suite++));

        // index : use for check exist "elif" or "else"
        int index = 4;
        while(true) {
            // break case
            if(index == ctx.getChildCount()) {
                break;
            }

            if(ctx.getChild(index) != null) {
                // match "elif"
                if(ctx.getChild(index).getText().equals("elif")) {
                    str += indent_string(else_indent) + "elif " + result.get(ctx.test(idx_test++)) + ":";
                    str += "\n" + result.get(ctx.suite(idx_suite++));
                    index += 4;
                }

                // match "else"
                else {
                    str += indent_string(else_indent) + "else:";
                    str += "\n" + result.get(ctx.suite(idx_suite++));
                    index += 3;
                }
            }
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitWhile_stmt(tinyPythonParser.While_stmtContext ctx) {
        String str = "while " + result.get(ctx.test()) + ":";
        str += "\n" + result.get(ctx.suite());

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitDef_stmt(tinyPythonParser.Def_stmtContext ctx) {
        String str = "def " + ctx.NAME().getText() + ctx.OPEN_PAREN().getText();
        str += result.get(ctx.args()) + ctx.CLOSE_PAREN().getText() + ":";
        str += "\n" + result.get(ctx.suite());

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void enterSuite(tinyPythonParser.SuiteContext ctx) {
        // this function is change indent level
        // suite uses only compound stmt (if, def, while)
        // indent level + 1 when entering suite
        num_indent++;
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

        // indent level + 1 when entering suite
        num_indent--;

        // else_indent variable is used to handle the indent of [ else: ]
        // [ else: ] handled in "exitIf_stmt" using else_indent
        else_indent = num_indent;
    }

    @Override
    public void exitArgs(tinyPythonParser.ArgsContext ctx) {
        String str = null;

        // handled 2 cases
        // case1 : [ NAME ("," NAME)* ]
        if(ctx.getChildCount() >= 1) {
            str = ctx.NAME(0).getText();
            for(int i = 1; i < (ctx.getChildCount()/2 + 1); i++) { // except ","
                str += ", " + ctx.NAME(i).getText();
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
        String str = "return";

        // case: return expr
        if(ctx.expr() != null) {
            str += " " + result.get(ctx.expr());
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitTest(tinyPythonParser.TestContext ctx) {
        String str = result.get(ctx.expr(0));
        int idx_op = 0;
        int idx_expr = 1;

        // handled (comp_op expr)*
        while(true) {
            if(ctx.comp_op(idx_op) == null) {
                break;
            }
            str += result.get(ctx.comp_op(idx_op++)) + result.get(ctx.expr(idx_expr++));
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitPrint_stmt(tinyPythonParser.Print_stmtContext ctx) {
        String str = "print " + result.get(ctx.print_arg());

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitPrint_arg(tinyPythonParser.Print_argContext ctx) {
        // handled 2 cases
        // case1 : STRING
        if(ctx.STRING() != null) {
            result.put(ctx, ctx.STRING().getText());
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
            result.put(ctx, " < ");
        }

        // case2 : ">"
        else if(ctx.getChild(0).getText().equals(">")) {
            result.put(ctx, " > ");
        }

        // case3 : ">"
        else if(ctx.getChild(0).getText().equals("==")) {
            result.put(ctx, " == ");
        }

        // case4 : ">"
        else if(ctx.getChild(0).getText().equals(">=")) {
            result.put(ctx, " >= ");
        }

        // case5 : ">"
        else if(ctx.getChild(0).getText().equals("<=")) {
            result.put(ctx, " <= ");
        }

        // case6 : ">"
        else {
            result.put(ctx, " != ");
        }
    }

    @Override
    public void exitExpr(tinyPythonParser.ExprContext ctx) {
        String str = null;

        // handled 4 cases
        // case1 : [ NAME opt_paren ] is getchildCount == 2
        if(ctx.getChildCount() == 2) {
            str = ctx.NAME().getText();
            if(result.get(ctx.opt_paren()) != null) {
                str += result.get(ctx.opt_paren());
            }
        }

        // case2 : [ NUMBER ] is getchildCount == 1
        else if(ctx.getChildCount() == 1) {
            str = ctx.NUMBER().getText();
        }

        // case3 : [ '(' expr ')' ] is getchildCount == 3
        // case4 : [ expr (('+' | '-') expr)+ ] is also getchildCount == 3
        // case3 and 4 is distinct by getchild(1) == operator or expr
        else {
            // case4 : binary operation
            if(ctx.getChild(1).getText().equals("+") | ctx.getChild(1).getText().equals("-")) {
                str = result.get(ctx.expr(0));

                if (ctx.getChild(1).getText().equals("+")) {
                    str += " + ";
                } else {
                    str += " - ";
                }

                if(ctx.expr(1) != null) {
                    str += result.get(ctx.expr(1));
                }
            }

            // case3
            else {
                str = "(" + result.get(ctx.expr(0)) + ")";
            }
        }

        // store string into result tree
        result.put(ctx, str);
    }

    @Override
    public void exitOpt_paren(tinyPythonParser.Opt_parenContext ctx) {
        String str = null;

        // handled 3 cases
        // case1 : [ '(' ')' ] is getchildCount == 2
        if(ctx.getChildCount() == 2) {
            str = "(" + ")";
        }

        // case2 : [ '(' expr (',' expr)* ')' ]
        else if(ctx.getChildCount() >= 3) {
            str = "(" + result.get(ctx.expr(0));
            int index = 1;

            for(int i = 2; i < ctx.getChildCount()-1; i+=2) {
                str += ", " + result.get(ctx.expr(index));
                index++;
            }

            str += ")";
        }

        // case3 : whitespace (공백)
        else {
            str = "";
        }

        // store string into result tree
        result.put(ctx, str);
    }
}
