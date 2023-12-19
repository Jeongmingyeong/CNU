import java.util.HashMap;
import java.util.Map;

public class SymbolTable {
    enum Type {
        INT, VOID, ERROR
    }

    // information about variables into hashtable
    public static class VarInfo {
        Type type;
        int id; // unique id of variable
        int initVal; // init value of variable

        public VarInfo(Type t_, int id_, int value_) {
            this.type = t_;
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
    }

    void initFuntable() {
        // insert default function to function_table
        FuncInfo printinfo = new FuncInfo();
        printinfo.function_signiture = "java/io/PrintStream/println(I)V";

        FuncInfo maininfo = new FuncInfo();
        maininfo.function_signiture= "main([Ljava/lang/String;)V";

        function_tbl.put("print", printinfo);
        function_tbl.put("main", maininfo);
    }
    // insert local variable to local_var_table
    void putVar(String varname, Type type, int value) {
        var_tbl.put(varname, new VarInfo(type, var_ID_++, value));
    }


    // mapping arguments to local variables
    void putParameter(tinyPythonParser.ArgsContext ctx) {
        for(int i = 0; i < ctx.NAME().size(); i++) {
            String arg_name = ctx.NAME(i).getText();

            putVar(arg_name, Type.INT, 0);
        }
    }


    String getVarName(String varname) {
        // if var exists in local_var_table, return id , convert to String
        VarInfo v = var_tbl.get(varname);
        if(v != null) {
            return Integer.toString(v.id);
        }

        // if not exist -> return ""
        return "";
    }

    String getLabelID() {
        return "label" + Integer.toString(label_ID_++);
    }

    String getFuncSigniture(String func_name) {
        return function_tbl.get(func_name).function_signiture;
    }
}
