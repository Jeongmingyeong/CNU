import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ErrorNode;
import org.antlr.v4.runtime.tree.ParseTreeProperty;
import org.antlr.v4.runtime.tree.TerminalNode;

import java.io.FileWriter;
import java.io.IOException;

public class tinyPythonCompilerListener extends tinyPythonBaseListener {

    // declaration of data structure
    ParseTreeProperty<String> result = new ParseTreeProperty<>();


    @Override
    public void enterProgram(tinyPythonParser.ProgramContext ctx) {
        super.enterProgram(ctx);
    }

    @Override
    public void exitProgram(tinyPythonParser.ProgramContext ctx) {
        String program = result.get(ctx.file_input());

        try {
            // create writer object
            FileWriter writer = new FileWriter("./Test.j");

            // append result to writer object
            writer.append(program);

            // create "Test.j" file
            writer.flush();

        } catch (IOException e) { // handling IOException
            System.out.println("can't find file");
            System.exit(1);
        }

    }

    @Override
    public void enterFile_input(tinyPythonParser.File_inputContext ctx) {
        // FIXME: store functions that definition this node in hash table
    }

    @Override
    public void exitFile_input(tinyPythonParser.File_inputContext ctx) {
        String str = "";
        int idx_newline = 0;
        int idx_stmt = 0;

        // handled defs
        if (ctx.getChild(0).equals(ctx.defs())) {
            str += result.get(ctx.defs());
        }

        // handled [ (NEWLINE | stmt)* EOF ]
        else {
            for (int i = 0; i < ctx.getChildCount(); ++i) {
                // case1 : NEWLINE
                if(ctx.getChild(i) == ctx.NEWLINE(idx_newline)) {
                    str += ctx.NEWLINE(idx_newline++);
                }

                // FIXME: case2 : stmt
                else {
                    str += result.get(ctx.stmt(idx_stmt++));
                }
            }
        }

        result.put(ctx, str);
    }

    @Override
    public void enterDefs(tinyPythonParser.DefsContext ctx) {
        super.enterDefs(ctx);
    }

    @Override
    public void exitDefs(tinyPythonParser.DefsContext ctx) {
        String str = "";
        int idx_newline = 0;
        int idx_defstmt = 0;

        // handled [ (NEWLINE| def_stmt)* ]
        for (int i = 0; i < ctx.getChildCount(); ++i) {
            // case1 : NEWLINE
            if(ctx.getChild(i) == ctx.NEWLINE(idx_newline)) {
                str += ctx.NEWLINE(idx_newline++);
            }

            // FIXME: case2 : stmt
            else {
                str += result.get(ctx.def_stmt(idx_defstmt++));
            }
        }

        result.put(ctx, str);
    }

    @Override
    public void enterStmt(tinyPythonParser.StmtContext ctx) {
        super.enterStmt(ctx);
    }

    @Override
    public void exitStmt(tinyPythonParser.StmtContext ctx) {
        String str = "";

        // handled [ simple_stmt ]
        if(ctx.simple_stmt() != null) {
            str += result.get(ctx.simple_stmt());
        }

        // handled [ compound_stmt ]
        else {
            str += result.get(ctx.compound_stmt());
        }

        result.put(ctx, str);
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
        super.enterAssignment_stmt(ctx);
    }

    @Override
    public void exitAssignment_stmt(tinyPythonParser.Assignment_stmtContext ctx) {
        super.exitAssignment_stmt(ctx);
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
    public void enterBreak_stmt(tinyPythonParser.Break_stmtContext ctx) {
        super.enterBreak_stmt(ctx);
    }

    @Override
    public void exitBreak_stmt(tinyPythonParser.Break_stmtContext ctx) {
        super.exitBreak_stmt(ctx);
    }

    @Override
    public void enterContinue_stmt(tinyPythonParser.Continue_stmtContext ctx) {
        super.enterContinue_stmt(ctx);
    }

    @Override
    public void exitContinue_stmt(tinyPythonParser.Continue_stmtContext ctx) {
        super.exitContinue_stmt(ctx);
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
        super.enterComp_op(ctx);
    }

    @Override
    public void exitComp_op(tinyPythonParser.Comp_opContext ctx) {
        super.exitComp_op(ctx);
    }

    @Override
    public void enterExpr(tinyPythonParser.ExprContext ctx) {
        super.enterExpr(ctx);
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
        super.visitTerminal(node);
    }

    @Override
    public void visitErrorNode(ErrorNode node) {
        super.visitErrorNode(node);
    }
}
