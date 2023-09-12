// Generated from /Users/jeongmingyeong/CNU/ITC_23/hw02/untitled/src/Expr.g4 by ANTLR 4.12.0
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link ExprParser}.
 */
public interface ExprListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link ExprParser#prog}.
	 * @param ctx the parse tree
	 */
	void enterProg(ExprParser.ProgContext ctx);
	/**
	 * Exit a parse tree produced by {@link ExprParser#prog}.
	 * @param ctx the parse tree
	 */
	void exitProg(ExprParser.ProgContext ctx);
	/**
	 * Enter a parse tree produced by {@link ExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void enterStmt(ExprParser.StmtContext ctx);
	/**
	 * Exit a parse tree produced by {@link ExprParser#stmt}.
	 * @param ctx the parse tree
	 */
	void exitStmt(ExprParser.StmtContext ctx);
	/**
	 * Enter a parse tree produced by {@link ExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void enterExpr(ExprParser.ExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link ExprParser#expr}.
	 * @param ctx the parse tree
	 */
	void exitExpr(ExprParser.ExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link ExprParser#multExpr}.
	 * @param ctx the parse tree
	 */
	void enterMultExpr(ExprParser.MultExprContext ctx);
	/**
	 * Exit a parse tree produced by {@link ExprParser#multExpr}.
	 * @param ctx the parse tree
	 */
	void exitMultExpr(ExprParser.MultExprContext ctx);
	/**
	 * Enter a parse tree produced by {@link ExprParser#atom}.
	 * @param ctx the parse tree
	 */
	void enterAtom(ExprParser.AtomContext ctx);
	/**
	 * Exit a parse tree produced by {@link ExprParser#atom}.
	 * @param ctx the parse tree
	 */
	void exitAtom(ExprParser.AtomContext ctx);
}