module F = Format

let expand_step = ref false
let result : (Ast.t * bool) list ref = ref []
let add_result (ast : Ast.t) (is_expand : bool) : unit = 
  result := !result @ [(ast, is_expand)]

let expand (term: Ast.t) : Ast.t =
  let _ = expand_step := true in
  match term with
  | ChurchConst cx when Option.is_some (int_of_string_opt cx) ->
      let num : int = int_of_string cx in
      let rec repeat_s n =
        if n <= 0 then ""
        else "s " ^ repeat_s (n - 1)
      in
      let encoding_num : string = "lambda s z -> " ^ repeat_s num ^ "z" in
      ParserMain.parse encoding_num
  | ChurchConst cx ->
      begin match cx with
      | "tru" -> ParserMain.parse "lambda x y -> x"
      | "fls" -> ParserMain.parse "lambda x y -> y"
      | "test" -> ParserMain.parse "lambda c t f -> c t f"
      | "and" -> ParserMain.parse "lambda b c -> b c fls"
      | "or" -> ParserMain.parse "lambda b c -> b tru c"
      | "not" -> ParserMain.parse "lambda c -> c fls tru"
      | "pair" -> ParserMain.parse "lambda f s b -> b f s"
      | "fst" -> ParserMain.parse "lambda p -> p tru"
      | "snd" -> ParserMain.parse "lambda p -> p fls"
      | "add" -> ParserMain.parse "lambda m n s z -> m s (n s z)"
      | "times" -> ParserMain.parse "lambda m n -> m (add n) 0"
      | "isZero" -> ParserMain.parse "lambda m -> m (lambda x -> fls) tru"
      | "zz" -> ParserMain.parse "pair 0 0"
      | "ss" -> ParserMain.parse "lambda p -> pair (snd p) (add 1 (snd p))"
      | "pred" -> ParserMain.parse "lambda m -> fst (m ss zz)"
      | "sub" -> ParserMain.parse "lambda m n -> n (lambda x -> isZero x) m"
      | "eq" -> ParserMain.parse "lambda m n -> (lambda x -> isZero x) (sub m n)"
      | "sum" -> ParserMain.parse "lambda x -> test (eq x 1) 1 (add x (sum (sub x 1)))"
      | s -> failwith (F.asprintf "unknown ChurchConst : %s" s) 
      end
  | Var "F" -> ParserMain.parse "lambda f x -> test (eq x 1) 1 (add x (f (sub x 1)))"
  | _ -> failwith "cannot expand. expand can only ChurchConst"


(* substitution : [v/x]t *)
let rec subst (x : string) (v : Ast.t) (t : Ast.t) : Ast.t =
  match t with
  | Var s -> 
      if x = s then v else (Var s)
  | LambdaAbs (s, t1) ->
      if s = x then LambdaAbs (s, t1)
      else LambdaAbs (s, step (subst x v t1))
  | App (t1, t2) ->
      App ((subst x v t1), (subst x v t2))
  | ChurchConst _ -> t 
    

(* Var "sum" : fix f 
   ChurchConst "sum" : can expand *)
and step (ast : Ast.t) : Ast.t =
  match ast with
  | Var "F" -> expand ast
  | Var "sum" -> let _ = expand_step := true in Ast.(App ((Var "F"), (ChurchConst "sum")))
  | App (LambdaAbs (x, t1), ChurchConst "sum") -> subst x (Var "sum") t1
  | App (LambdaAbs (x, t1), t2) -> subst x t2 t1
  | App (t1, (ChurchConst _ as t2)) -> App (t1, (step t2))
  | App (t1, t2) -> App ((step t1), t2)
  | ChurchConst _ -> expand ast
  | LambdaAbs (x, body) ->
      let body' = step body in
      LambdaAbs (x, body')
  | _ -> ast

let rec get_normal_form (ast : Ast.t) : Ast.t =
  let step_res : Ast.t = step ast in
  if Ast.equal ast step_res then step_res
  else
    let _ = add_result step_res !expand_step in
    let _ = expand_step := false in
    get_normal_form step_res

let start (ast: Ast.t) : Ast.t = 
  let _ = expand_step := false in
  let _ = result := [(ast, !expand_step)] in
  get_normal_form ast


