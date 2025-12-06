
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | WHILE
    | TRUE
    | STAR
    | SEMICOLON
    | RIGHT_PARENTHESIS
    | RIGHT_BRACE
    | REF
    | PLUS
    | OR
    | NUMBER of (
# 4 "parser/parser.mly"
       (int)
# 24 "parser/parser.ml"
  )
    | MINUS
    | LESSTHAN
    | LEFT_PARENTHESIS
    | LEFT_BRACE
    | IF
    | ID of (
# 5 "parser/parser.mly"
       (string)
# 34 "parser/parser.ml"
  )
    | GREATERTHAN
    | FALSE
    | EQ
    | EOF
    | ELSE
    | DEF
    | AND
  
end

include MenhirBasics

# 1 "parser/parser.mly"
  
  open Ast

# 52 "parser/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_parse) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: parse. *)

  | MenhirState01 : (('s, _menhir_box_parse) _menhir_cell1_WHILE, _menhir_box_parse) _menhir_state
    (** State 01.
        Stack shape : WHILE.
        Start symbol: parse. *)

  | MenhirState06 : (('s, _menhir_box_parse) _menhir_cell1_LEFT_PARENTHESIS, _menhir_box_parse) _menhir_state
    (** State 06.
        Stack shape : LEFT_PARENTHESIS.
        Start symbol: parse. *)

  | MenhirState11 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 11.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState13 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 13.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState15 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 15.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState17 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 17.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState19 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 19.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState20 : ((('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_cell1_EQ, _menhir_box_parse) _menhir_state
    (** State 20.
        Stack shape : expr EQ.
        Start symbol: parse. *)

  | MenhirState22 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 22.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState24 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 24.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState27 : ((('s, _menhir_box_parse) _menhir_cell1_WHILE, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 27.
        Stack shape : WHILE expr.
        Start symbol: parse. *)

  | MenhirState28 : (('s, _menhir_box_parse) _menhir_cell1_STAR, _menhir_box_parse) _menhir_state
    (** State 28.
        Stack shape : STAR.
        Start symbol: parse. *)

  | MenhirState30 : ((('s, _menhir_box_parse) _menhir_cell1_STAR, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 30.
        Stack shape : STAR expr.
        Start symbol: parse. *)

  | MenhirState33 : (('s, _menhir_box_parse) _menhir_cell1_IF, _menhir_box_parse) _menhir_state
    (** State 33.
        Stack shape : IF.
        Start symbol: parse. *)

  | MenhirState35 : ((('s, _menhir_box_parse) _menhir_cell1_IF, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 35.
        Stack shape : IF expr.
        Start symbol: parse. *)

  | MenhirState37 : (('s, _menhir_box_parse) _menhir_cell1_ID, _menhir_box_parse) _menhir_state
    (** State 37.
        Stack shape : ID.
        Start symbol: parse. *)

  | MenhirState38 : ((('s, _menhir_box_parse) _menhir_cell1_ID, _menhir_box_parse) _menhir_cell1_STAR, _menhir_box_parse) _menhir_state
    (** State 38.
        Stack shape : ID STAR.
        Start symbol: parse. *)

  | MenhirState46 : (('s, _menhir_box_parse) _menhir_cell1_stmt, _menhir_box_parse) _menhir_state
    (** State 46.
        Stack shape : stmt.
        Start symbol: parse. *)

  | MenhirState51 : (((('s, _menhir_box_parse) _menhir_cell1_IF, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_cell1_list_stmt_, _menhir_box_parse) _menhir_state
    (** State 51.
        Stack shape : IF expr list(stmt).
        Start symbol: parse. *)


and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_list_stmt_ = 
  | MenhirCell1_list_stmt_ of 's * ('s, 'r) _menhir_state * (Ast.stmt list)

and ('s, 'r) _menhir_cell1_stmt = 
  | MenhirCell1_stmt of 's * ('s, 'r) _menhir_state * (Ast.stmt)

and ('s, 'r) _menhir_cell1_EQ = 
  | MenhirCell1_EQ of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_ID = 
  | MenhirCell1_ID of 's * ('s, 'r) _menhir_state * (
# 5 "parser/parser.mly"
       (string)
# 172 "parser/parser.ml"
)

and ('s, 'r) _menhir_cell1_IF = 
  | MenhirCell1_IF of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LEFT_PARENTHESIS = 
  | MenhirCell1_LEFT_PARENTHESIS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_STAR = 
  | MenhirCell1_STAR of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_WHILE = 
  | MenhirCell1_WHILE of 's * ('s, 'r) _menhir_state

and _menhir_box_parse = 
  | MenhirBox_parse of (Ast.prog) [@@unboxed]

let _menhir_action_01 =
  fun n ->
    (
# 29 "parser/parser.mly"
             ( Num n )
# 195 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_02 =
  fun x ->
    (
# 30 "parser/parser.mly"
         ( Id x )
# 203 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_03 =
  fun x ->
    (
# 31 "parser/parser.mly"
             ( Ref x )
# 211 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_04 =
  fun () ->
    (
# 32 "parser/parser.mly"
         ( Bool true )
# 219 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_05 =
  fun () ->
    (
# 33 "parser/parser.mly"
          ( Bool false )
# 227 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_06 =
  fun e ->
    (
# 34 "parser/parser.mly"
                                              ( e )
# 235 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_07 =
  fun e1 e2 ->
    (
# 35 "parser/parser.mly"
                         ( Add (e1, e2) )
# 243 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_08 =
  fun e1 e2 ->
    (
# 36 "parser/parser.mly"
                          ( Sub (e1, e2) )
# 251 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_09 =
  fun e1 e2 ->
    (
# 37 "parser/parser.mly"
                             ( Lt (e1, e2) )
# 259 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_10 =
  fun e1 e2 ->
    (
# 38 "parser/parser.mly"
                                ( Gt (e1, e2) )
# 267 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_11 =
  fun e1 e2 ->
    (
# 39 "parser/parser.mly"
                          ( Eq (e1, e2) )
# 275 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_12 =
  fun e1 e2 ->
    (
# 40 "parser/parser.mly"
                        ( And (e1, e2) )
# 283 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_13 =
  fun e1 e2 ->
    (
# 41 "parser/parser.mly"
                       ( Or (e1, e2) )
# 291 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_14 =
  fun () ->
    (
# 208 "<standard.mly>"
    ( [] )
# 299 "parser/parser.ml"
     : (Ast.stmt list))

let _menhir_action_15 =
  fun x xs ->
    (
# 210 "<standard.mly>"
    ( x :: xs )
# 307 "parser/parser.ml"
     : (Ast.stmt list))

let _menhir_action_16 =
  fun sl ->
    (
# 17 "parser/parser.mly"
                 ( Program sl )
# 315 "parser/parser.ml"
     : (Ast.prog))

let _menhir_action_17 =
  fun e sl ->
    (
# 20 "parser/parser.mly"
                                                 ( LoopStmt (e, sl) )
# 323 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_18 =
  fun x ->
    (
# 21 "parser/parser.mly"
                       ( DefStmt x )
# 331 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_19 =
  fun e x ->
    (
# 22 "parser/parser.mly"
                             ( StoreStmt (Ref x, e) )
# 339 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_20 =
  fun e x ->
    (
# 23 "parser/parser.mly"
                                  ( LoadStmt (x, e) )
# 347 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_21 =
  fun e1 e2 ->
    (
# 24 "parser/parser.mly"
                                      ( StoreStmt (e1, e2) )
# 355 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_22 =
  fun e sl ->
    (
# 25 "parser/parser.mly"
                                              ( IfStmt (e, sl, []) )
# 363 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_action_23 =
  fun e sl1 sl2 ->
    (
# 26 "parser/parser.mly"
                                                                                     ( IfStmt (e, sl1, sl2) )
# 371 "parser/parser.ml"
     : (Ast.stmt))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | AND ->
        "AND"
    | DEF ->
        "DEF"
    | ELSE ->
        "ELSE"
    | EOF ->
        "EOF"
    | EQ ->
        "EQ"
    | FALSE ->
        "FALSE"
    | GREATERTHAN ->
        "GREATERTHAN"
    | ID _ ->
        "ID"
    | IF ->
        "IF"
    | LEFT_BRACE ->
        "LEFT_BRACE"
    | LEFT_PARENTHESIS ->
        "LEFT_PARENTHESIS"
    | LESSTHAN ->
        "LESSTHAN"
    | MINUS ->
        "MINUS"
    | NUMBER _ ->
        "NUMBER"
    | OR ->
        "OR"
    | PLUS ->
        "PLUS"
    | REF ->
        "REF"
    | RIGHT_BRACE ->
        "RIGHT_BRACE"
    | RIGHT_PARENTHESIS ->
        "RIGHT_PARENTHESIS"
    | SEMICOLON ->
        "SEMICOLON"
    | STAR ->
        "STAR"
    | TRUE ->
        "TRUE"
    | WHILE ->
        "WHILE"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37-39"]
  
  let rec _menhir_run_57 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _v _tok ->
      match (_tok : MenhirBasics.token) with
      | EOF ->
          let sl = _v in
          let _v = _menhir_action_16 sl in
          MenhirBox_parse _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_WHILE (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState01
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState01
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState01 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_26 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_WHILE as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEFT_BRACE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | WHILE ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState27
          | STAR ->
              _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState27
          | IF ->
              _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState27
          | ID _v ->
              _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState27
          | DEF ->
              _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState27
          | RIGHT_BRACE ->
              let _v = _menhir_action_14 () in
              _menhir_run_54 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
          | _ ->
              _eRR ())
      | GREATERTHAN ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_11 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState11 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState11 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState11
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState11 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState11 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_12 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEFT_BRACE | MINUS | PLUS | RIGHT_PARENTHESIS | SEMICOLON ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_07 e1 e2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_13 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState13
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_14 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_13 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState37 ->
          _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState38 ->
          _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState33 ->
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState30 ->
          _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState28 ->
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState01 ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState24 ->
          _menhir_run_25 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState22 ->
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState20 ->
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState17 ->
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState15 ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState13 ->
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState11 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_41 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_ID as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_ID (_menhir_stack, _menhir_s, x) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_19 e x in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_goto_stmt : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_stmt (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | WHILE ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState46
      | STAR ->
          _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState46
      | IF ->
          _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState46
      | ID _v_0 ->
          _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState46
      | DEF ->
          _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState46
      | EOF | RIGHT_BRACE ->
          let _v = _menhir_action_14 () in
          _menhir_run_47 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_28 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_STAR (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState28 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState28
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState28 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState28
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState28 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState28 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_29 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_STAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | TRUE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_04 () in
              _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState30 _tok
          | REF ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState30
          | NUMBER _v_1 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let n = _v_1 in
              let _v = _menhir_action_01 n in
              _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState30 _tok
          | LEFT_PARENTHESIS ->
              _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState30
          | ID _v_3 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = _v_3 in
              let _v = _menhir_action_02 x in
              _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState30 _tok
          | FALSE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_05 () in
              _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState30 _tok
          | EQ ->
              _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState30
          | _ ->
              _eRR ())
      | AND ->
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_24 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_25 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState24 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState24
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_25 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState24 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState24
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_25 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState24 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_25 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState24 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_25 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEFT_BRACE | MINUS | PLUS | RIGHT_PARENTHESIS | SEMICOLON ->
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_08 e1 e2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState15
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState15
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_16 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_09 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_03 x in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_06 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_PARENTHESIS (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_09 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_LEFT_PARENTHESIS as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RIGHT_PARENTHESIS ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LEFT_PARENTHESIS (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_06 e in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_17 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState17
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_18 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_10 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_19 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | EQ ->
          _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState19
      | _ ->
          _eRR ()
  
  and _menhir_run_20 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_expr as 'stack) -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_EQ (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState20 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState20
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState20 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState20
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState20 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState20 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_21 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_cell1_EQ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ | LEFT_BRACE | MINUS | PLUS | RIGHT_PARENTHESIS | SEMICOLON ->
          let MenhirCell1_EQ (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_11 e1 e2 in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_22 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState22
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState22
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_23 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_12 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_31 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_STAR, _menhir_box_parse) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_expr (_menhir_stack, _, e1) = _menhir_stack in
          let MenhirCell1_STAR (_menhir_stack, _menhir_s) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_21 e1 e2 in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_33 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_IF (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | TRUE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_04 () in
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState33 _tok
      | REF ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState33
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_01 n in
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState33 _tok
      | LEFT_PARENTHESIS ->
          _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState33
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let x = _v in
          let _v = _menhir_action_02 x in
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState33 _tok
      | FALSE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let _v = _menhir_action_05 () in
          _menhir_run_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState33 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_34 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_IF as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LEFT_BRACE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | WHILE ->
              _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState35
          | STAR ->
              _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState35
          | IF ->
              _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState35
          | ID _v ->
              _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState35
          | DEF ->
              _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState35
          | RIGHT_BRACE ->
              let _v = _menhir_action_14 () in
              _menhir_run_48 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState35 _tok
          | _ ->
              _eRR ())
      | GREATERTHAN ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_36 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | EQ ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | TRUE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_04 () in
              _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState37 _tok
          | STAR ->
              let _menhir_stack = MenhirCell1_STAR (_menhir_stack, MenhirState37) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | TRUE ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let _v = _menhir_action_04 () in
                  _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState38 _tok
              | REF ->
                  _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState38
              | NUMBER _v_2 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let n = _v_2 in
                  let _v = _menhir_action_01 n in
                  _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState38 _tok
              | LEFT_PARENTHESIS ->
                  _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState38
              | ID _v_4 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let x = _v_4 in
                  let _v = _menhir_action_02 x in
                  _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState38 _tok
              | FALSE ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let _v = _menhir_action_05 () in
                  _menhir_run_39 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState38 _tok
              | _ ->
                  _eRR ())
          | REF ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState37
          | NUMBER _v_7 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let n = _v_7 in
              let _v = _menhir_action_01 n in
              _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState37 _tok
          | LEFT_PARENTHESIS ->
              _menhir_run_06 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState37
          | ID _v_9 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = _v_9 in
              let _v = _menhir_action_02 x in
              _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState37 _tok
          | FALSE ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let _v = _menhir_action_05 () in
              _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState37 _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_39 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_ID, _menhir_box_parse) _menhir_cell1_STAR as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | SEMICOLON ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_STAR (_menhir_stack, _) = _menhir_stack in
          let MenhirCell1_ID (_menhir_stack, _menhir_s, x) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_20 e x in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer
      | OR ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_24 _menhir_stack _menhir_lexbuf _menhir_lexer
      | LESSTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer
      | GREATERTHAN ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EQ ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer
      | AND ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_run_43 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | SEMICOLON ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = _v in
              let _v = _menhir_action_18 x in
              _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_48 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_IF, _menhir_box_parse) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RIGHT_BRACE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ELSE ->
              let _menhir_stack = MenhirCell1_list_stmt_ (_menhir_stack, _menhir_s, _v) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | LEFT_BRACE ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  (match (_tok : MenhirBasics.token) with
                  | WHILE ->
                      _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState51
                  | STAR ->
                      _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState51
                  | IF ->
                      _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState51
                  | ID _v ->
                      _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState51
                  | DEF ->
                      _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState51
                  | RIGHT_BRACE ->
                      let _v = _menhir_action_14 () in
                      _menhir_run_52 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
                  | _ ->
                      _eRR ())
              | _ ->
                  _eRR ())
          | DEF | EOF | ID _ | IF | RIGHT_BRACE | STAR | WHILE ->
              let MenhirCell1_expr (_menhir_stack, _, e) = _menhir_stack in
              let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
              let sl = _v in
              let _v = _menhir_action_22 e sl in
              _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_52 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_IF, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_cell1_list_stmt_ -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RIGHT_BRACE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_list_stmt_ (_menhir_stack, _, sl1) = _menhir_stack in
          let MenhirCell1_expr (_menhir_stack, _, e) = _menhir_stack in
          let MenhirCell1_IF (_menhir_stack, _menhir_s) = _menhir_stack in
          let sl2 = _v in
          let _v = _menhir_action_23 e sl1 sl2 in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_47 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_stmt -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_stmt (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let xs = _v in
      let _v = _menhir_action_15 x xs in
      _menhir_goto_list_stmt_ _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_list_stmt_ : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_57 _menhir_stack _v _tok
      | MenhirState27 ->
          _menhir_run_54 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState51 ->
          _menhir_run_52 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState35 ->
          _menhir_run_48 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState46 ->
          _menhir_run_47 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_54 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_WHILE, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RIGHT_BRACE ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_expr (_menhir_stack, _, e) = _menhir_stack in
          let MenhirCell1_WHILE (_menhir_stack, _menhir_s) = _menhir_stack in
          let sl = _v in
          let _v = _menhir_action_17 e sl in
          _menhir_goto_stmt _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  let rec _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | WHILE ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | STAR ->
          _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | IF ->
          _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | ID _v ->
          _menhir_run_36 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState00
      | DEF ->
          _menhir_run_43 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | EOF ->
          let _v = _menhir_action_14 () in
          _menhir_run_57 _menhir_stack _v _tok
      | _ ->
          _eRR ()
  
end

let parse =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_parse v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
