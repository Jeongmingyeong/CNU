import java.util.HashMap;
import java.util.Map;

public class SymbolTable {

    // information about variables into hashtable
    public static class VarInfo {
        int id; // unique id of variable
        String initVal; // init value of variable

        public VarInfo(int id_, String value_) {
            this.id = id_;
            this.initVal = value_;
        }
    }

    public static class FuncInfo {
        // This function_code refers to the string
        // when the function call is converted to Java byte code.
        // ex) "print" => "java/io/PrintStream/println(I)V" (function_code)
        String function_signiture;
    }

    // create local_var_table, global_var_table, function_table, label_table(todo)
    private Map<String, VarInfo> var_tbl = new HashMap<>();
    private Map<String, FuncInfo> function_tbl = new HashMap<>();

    // unique ID (local_var)
    private int var_ID_ = 0;

    // label number (unique ID)
    // create the number of label position (e.g. loopstart, loopend, else_stmt...)
    private int label_ID_ = 0;

    SymbolTable() {
        initFunDecl();
        initFuntable();
    }

    void initFunDecl() {
        // this method performs initializing ID numbers used only within the function to 0
        // when handled function declaration
        var_ID_ = 0;
        label_ID_ = 0;
    }

    void initFuntable() {
        // insert default function to function_table
        FuncInfo printinfoInt = new FuncInfo();
        printinfoInt.function_signiture = "java/io/PrintStream/println(I)V"; // for print Integer

        FuncInfo printinfoStr = new FuncInfo();
        printinfoStr.function_signiture = "java/io/PrintStream/println(Ljava/lang/String;)V"; // for print Integer

        FuncInfo maininfo = new FuncInfo();
        maininfo.function_signiture= "main([Ljava/lang/String;)V";

        function_tbl.put("print_I", printinfoInt);
        function_tbl.put("print_S", printinfoStr);
        function_tbl.put("main", maininfo);
    }
    // insert local variable to local_var_table
    void putVar(String varname, String value) {
        if(var_tbl.get(varname) != null) {
            // already exist
            var_tbl.put(varname, new VarInfo(var_tbl.get(varname).id, value));
        } else {
            // new variable
            var_tbl.put(varname, new VarInfo(var_ID_++, value));
        }
    }

    String getVarID(String varname) {
        // if var exists in local_var_table, return id , convert to String
        VarInfo v = var_tbl.get(varname);
        if(v != null) {
            return Integer.toString(v.id);
        }

        // if not exist -> return ""
        return "";
    }

    String newLabelID() {
        return "Label" + Integer.toString(label_ID_++);
    }

    String getFuncSigniture(String func_name) {
        if(function_tbl.get(func_name).function_signiture != null) {
            return function_tbl.get(func_name).function_signiture;
        }

        return "";
    }

    String putFuncSigniture(tinyPythonParser.Def_stmtContext ctx) {
        String fname = ctx.NAME().getText(); // function name
        String args_type = ""; // # of args Type ( ex) a(b, c) => II )
        String return_type = "I"; // return type
        String fsig = "";

        if(ctx.args().getChildCount() == 0) {
            // [ args : "" ]
            args_type = "";
        } else {
            // at least one argument exist
            int arg_num = (ctx.args().getChildCount() / 2) + 1; // # of argument
            args_type = "I".repeat(arg_num); // if # arg == 2 => args_type : II
        }

        fsig = fname + "(" + args_type + ")" + return_type;

        FuncInfo finfo = new FuncInfo();
        finfo.function_signiture = fsig;
        function_tbl.put(fname, finfo);

        return fsig;
    }
}
