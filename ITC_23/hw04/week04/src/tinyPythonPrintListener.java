import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTreeProperty;
import org.antlr.v4.runtime.tree.TerminalNode;

public class tinyPythonPrintListener extends tinyPythonBaseListener {
    ParseTreeProperty<String> result = new ParseTreeProperty<>();

//    @Override
//    public void enterProgram(tinyPythonParser.ProgramContext ctx) {
//        super.enterProgram(ctx);
//    }

    @Override
    public void exitProgram(tinyPythonParser.ProgramContext ctx) {
        System.out.println(ctx.getChild(0).getText());
        System.out.println("exit Program");
    }

//    @Override
//    public void enterFile_input(tinyPythonParser.File_inputContext ctx) {
//        super.enterFile_input(ctx);
//    }
//
//    @Override
//    public void exitFile_input(tinyPythonParser.File_inputContext ctx) {
//        super.exitFile_input(ctx);
//    }

    @Override
    public void enterStmt(tinyPythonParser.StmtContext ctx) {
        String str = "";

        // case1 :
        }

    }

    @Override
    public void exitStmt(tinyPythonParser.StmtContext ctx) {
        super.exitStmt(ctx);
    }

    @Override
    public void enterSimple_stmt(tinyPythonParser.Simple_stmtContext ctx) {
        super.enterSimple_stmt(ctx);
    }

    @Override
    public void exitSimple_stmt(tinyPythonParser.Simple_stmtContext ctx) {
        super.exitSimple_stmt(ctx);
    }

    @Override
    public void enterSmall_stmt(tinyPythonParser.Small_stmtContext ctx) {
        super.enterSmall_stmt(ctx);
    }

    @Override
    public void exitSmall_stmt(tinyPythonParser.Small_stmtContext ctx) {
        super.exitSmall_stmt(ctx);
    }

    @Override
    public void enterAssignment_stmt(tinyPythonParser.Assignment_stmtContext ctx) {
//        System.out.println(ctx.getParent());
//        System.out.println("the number of child : " + Integer.toString(ctx.getChildCount()));

        for (int i = 0; i < ctx.getChildCount(); i++) {

            // 지금 출력할 token 이 "=" token 이면 앞뒤로 공백 추가
            if(ctx.getChild(i).getText().equals("=")) {
                System.out.print(" " + ctx.getChild(i).getText() + " ");
                continue;
            }

            // otherwise
            System.out.print(ctx.getChild(i).getText());
        }
    }


    @Override
    public void exitAssignment_stmt(tinyPythonParser.Assignment_stmtContext ctx) {
        // 각 line 구분
        System.out.println();
    }

    @Override
    public void enterFlow_stmt(tinyPythonParser.Flow_stmtContext ctx) {
        super.enterFlow_stmt(ctx);
    }

    @Override
    public void exitFlow_stmt(tinyPythonParser.Flow_stmtContext ctx) {
        super.exitFlow_stmt(ctx);
    }

    @Override
    public void exitBreak_stmt(tinyPythonParser.Break_stmtContext ctx) {
    	System.out.println("Break");
	}

    @Override
    public void exitContinue_stmt(tinyPythonParser.Continue_stmtContext ctx) {
        System.out.println("continue");
    }

    @Override
    public void enterCompound_stmt(tinyPythonParser.Compound_stmtContext ctx) {
        super.enterCompound_stmt(ctx);
    }

    @Override
    public void exitCompound_stmt(tinyPythonParser.Compound_stmtContext ctx) {
        super.exitCompound_stmt(ctx);
    }

    @Override
    public void enterIf_stmt(tinyPythonParser.If_stmtContext ctx) {
        super.enterIf_stmt(ctx);
    }

    @Override
    public void exitIf_stmt(tinyPythonParser.If_stmtContext ctx) {
        super.exitIf_stmt(ctx);
    }

    @Override
    public void enterWhile_stmt(tinyPythonParser.While_stmtContext ctx) {
        super.enterWhile_stmt(ctx);
    }

    @Override
    public void exitWhile_stmt(tinyPythonParser.While_stmtContext ctx) {
        super.exitWhile_stmt(ctx);
    }

    @Override
    public void enterDef_stmt(tinyPythonParser.Def_stmtContext ctx) {
        super.enterDef_stmt(ctx);
    }

    @Override
    public void exitDef_stmt(tinyPythonParser.Def_stmtContext ctx) {
        super.exitDef_stmt(ctx);
    }

    @Override
    public void enterSuite(tinyPythonParser.SuiteContext ctx) {
        super.enterSuite(ctx);
    }

    @Override
    public void exitSuite(tinyPythonParser.SuiteContext ctx) {
        super.exitSuite(ctx);
    }

    @Override
    public void enterArgs(tinyPythonParser.ArgsContext ctx) {
        super.enterArgs(ctx);
    }

    @Override
    public void exitArgs(tinyPythonParser.ArgsContext ctx) {
        super.exitArgs(ctx);
    }

    @Override
    public void enterReturn_stmt(tinyPythonParser.Return_stmtContext ctx) {
        super.enterReturn_stmt(ctx);
    }

    @Override
    public void exitReturn_stmt(tinyPythonParser.Return_stmtContext ctx) {
        super.exitReturn_stmt(ctx);
    }

    @Override
    public void enterTest(tinyPythonParser.TestContext ctx) {
        super.enterTest(ctx);
    }

    @Override
    public void exitTest(tinyPythonParser.TestContext ctx) {
        super.exitTest(ctx);
    }

    @Override
    public void enterPrint_stmt(tinyPythonParser.Print_stmtContext ctx) {
        super.enterPrint_stmt(ctx);
    }

    @Override
    public void exitPrint_stmt(tinyPythonParser.Print_stmtContext ctx) {
        super.exitPrint_stmt(ctx);
    }

    @Override
    public void enterPrint_arg(tinyPythonParser.Print_argContext ctx) {
        super.enterPrint_arg(ctx);
    }

    @Override
    public void exitPrint_arg(tinyPythonParser.Print_argContext ctx) {
        super.exitPrint_arg(ctx);
    }

    @Override
    public void enterComp_op(tinyPythonParser.Comp_opContext ctx) {
        // operation 앞뒤로 공백 붙여 출력
        System.out.print(" " + ctx.getChild(0).getText() + " ");
    }

//    @Override
//    public void exitComp_op(tinyPythonParser.Comp_opContext ctx) {
//        super.exitComp_op(ctx);
//    }

    @Override
    public void enterExpr(tinyPythonParser.ExprContext ctx) {
        System.out.println("start test : " + Integer.toString(ctx.getChildCount()));
        for(int i = 0; i < ctx.getChildCount(); i++) {

            // "+" or "-" operator 라면 앞뒤로 공백 추가해 출력
            if (ctx.getChild(i).getText().equals("+") || ctx.getChild(i).getText().equals("-")) {
                System.out.println(" " + ctx.getChild(i).getText() + " ");
                continue;
            }

            System.out.print(ctx.getChild(i).getText());
        }
        System.out.println("end test");

//        System.out.println(ctx);
    }

    @Override
    public void exitExpr(tinyPythonParser.ExprContext ctx) {
        super.exitExpr(ctx);

    }

    @Override
    public void enterOpt_paren(tinyPythonParser.Opt_parenContext ctx) {
        super.enterOpt_paren(ctx);
    }

    @Override
    public void exitOpt_paren(tinyPythonParser.Opt_parenContext ctx) {
        super.exitOpt_paren(ctx);
    }

    @Override
    public void enterEveryRule(ParserRuleContext ctx) {
        super.enterEveryRule(ctx);
    }

    @Override
    public void exitEveryRule(ParserRuleContext ctx) {
        super.exitEveryRule(ctx);
    }

    @Override
    public void visitTerminal(TerminalNode node) {
//        super.visitTerminal(node);
//        System.out.println("type: " + node.getSymbol().getType()) ;
    }

    @Override
    public void visitErrorNode(ErrorNode node) {
        super.visitErrorNode(node);
    }
}
