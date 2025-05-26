%{
  open Ast
%}

%token <string> ID
%token <string> CONST
%token KW_LAMBDA
%token ARROW
%token LEFT_PAREN RIGHT_PAREN
%token EOF

%start <Ast.t> parse
%%

parse:
  | t=term EOF { t }
  ;

term:
  | t=app_term { t }
  ;

app_term:
  | t=atom ts=atom_list { List.fold_left (fun acc arg -> App (acc, arg)) t ts }
  ;

atom_list:
  |  { [] }
  | t=atom tl=atom_list { t :: tl }
  ;

atom:
  | x=ID { Var x }
  | cx=CONST { ChurchConst cx }
  | KW_LAMBDA vl=var_list ARROW body=term {
      List.fold_right (fun x acc -> LambdaAbs (x, acc)) vl body
    }
  | LEFT_PAREN t=term RIGHT_PAREN { t }
  ;

var_list:
  | x=ID { [x] }
  | x=ID vl=var_list { x :: vl }
  ;

