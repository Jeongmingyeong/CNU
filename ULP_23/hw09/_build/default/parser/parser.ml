
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | RIGHT_PARENTHESIS
    | PLUS
    | NUMBER of (
# 4 "parser/parser.mly"
       (int)
# 17 "parser/parser.ml"
  )
    | NEG
    | MINUS
    | LEFT_PARENTHESIS
    | KW_LET
    | KW_IN
    | KW_ENDEF
    | KW_DEF
    | ID of (
# 5 "parser/parser.mly"
       (string)
# 29 "parser/parser.ml"
  )
    | EQ
    | EOF
    | COMMA
  
end

include MenhirBasics

# 1 "parser/parser.mly"
  
  open Ast

# 43 "parser/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_parse) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: parse. *)

  | MenhirState02 : (('s, _menhir_box_parse) _menhir_cell1_NEG, _menhir_box_parse) _menhir_state
    (** State 02.
        Stack shape : NEG.
        Start symbol: parse. *)

  | MenhirState03 : (('s, _menhir_box_parse) _menhir_cell1_LEFT_PARENTHESIS, _menhir_box_parse) _menhir_state
    (** State 03.
        Stack shape : LEFT_PARENTHESIS.
        Start symbol: parse. *)

  | MenhirState06 : (('s, _menhir_box_parse) _menhir_cell1_KW_LET _menhir_cell0_ID, _menhir_box_parse) _menhir_state
    (** State 06.
        Stack shape : KW_LET ID.
        Start symbol: parse. *)

  | MenhirState08 : (('s, _menhir_box_parse) _menhir_cell1_ID, _menhir_box_parse) _menhir_state
    (** State 08.
        Stack shape : ID.
        Start symbol: parse. *)

  | MenhirState14 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 14.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState16 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 16.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState18 : (('s, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 18.
        Stack shape : expr.
        Start symbol: parse. *)

  | MenhirState21 : ((('s, _menhir_box_parse) _menhir_cell1_KW_LET _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_expr, _menhir_box_parse) _menhir_state
    (** State 21.
        Stack shape : KW_LET ID expr.
        Start symbol: parse. *)

  | MenhirState27 : (('s, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_state
    (** State 27.
        Stack shape : KW_DEF ID.
        Start symbol: parse. *)

  | MenhirState28 : (('s, _menhir_box_parse) _menhir_cell1_ID, _menhir_box_parse) _menhir_state
    (** State 28.
        Stack shape : ID.
        Start symbol: parse. *)

  | MenhirState30 : ((('s, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_EQ, _menhir_box_parse) _menhir_state
    (** State 30.
        Stack shape : KW_DEF ID EQ.
        Start symbol: parse. *)

  | MenhirState34 : ((('s, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_var_list, _menhir_box_parse) _menhir_state
    (** State 34.
        Stack shape : KW_DEF ID var_list.
        Start symbol: parse. *)

  | MenhirState40 : (('s, _menhir_box_parse) _menhir_cell1_decl_list, _menhir_box_parse) _menhir_state
    (** State 40.
        Stack shape : decl_list.
        Start symbol: parse. *)

  | MenhirState43 : (('s, _menhir_box_parse) _menhir_cell1_decl, _menhir_box_parse) _menhir_state
    (** State 43.
        Stack shape : decl.
        Start symbol: parse. *)


and ('s, 'r) _menhir_cell1_decl = 
  | MenhirCell1_decl of 's * ('s, 'r) _menhir_state * (Ast.fundef)

and ('s, 'r) _menhir_cell1_decl_list = 
  | MenhirCell1_decl_list of 's * ('s, 'r) _menhir_state * (Ast.fundef list)

and ('s, 'r) _menhir_cell1_expr = 
  | MenhirCell1_expr of 's * ('s, 'r) _menhir_state * (Ast.expr)

and ('s, 'r) _menhir_cell1_var_list = 
  | MenhirCell1_var_list of 's * ('s, 'r) _menhir_state * (string list)

and ('s, 'r) _menhir_cell1_EQ = 
  | MenhirCell1_EQ of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_ID = 
  | MenhirCell1_ID of 's * ('s, 'r) _menhir_state * (
# 5 "parser/parser.mly"
       (string)
# 141 "parser/parser.ml"
)

and 's _menhir_cell0_ID = 
  | MenhirCell0_ID of 's * (
# 5 "parser/parser.mly"
       (string)
# 148 "parser/parser.ml"
)

and ('s, 'r) _menhir_cell1_KW_DEF = 
  | MenhirCell1_KW_DEF of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_KW_LET = 
  | MenhirCell1_KW_LET of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LEFT_PARENTHESIS = 
  | MenhirCell1_LEFT_PARENTHESIS of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_NEG = 
  | MenhirCell1_NEG of 's * ('s, 'r) _menhir_state

and _menhir_box_parse = 
  | MenhirBox_parse of (Ast.prog) [@@unboxed]

let _menhir_action_01 =
  fun e x ->
    (
# 25 "parser/parser.mly"
                                   ( FunDef (x, [], e) )
# 171 "parser/parser.ml"
     : (Ast.fundef))

let _menhir_action_02 =
  fun e vlst x ->
    (
# 26 "parser/parser.mly"
                                                 ( FunDef (x, vlst, e) )
# 179 "parser/parser.ml"
     : (Ast.fundef))

let _menhir_action_03 =
  fun d ->
    (
# 21 "parser/parser.mly"
           ( [d] )
# 187 "parser/parser.ml"
     : (Ast.fundef list))

let _menhir_action_04 =
  fun d dlst ->
    (
# 22 "parser/parser.mly"
                          ( d :: dlst )
# 195 "parser/parser.ml"
     : (Ast.fundef list))

let _menhir_action_05 =
  fun e1 e2 x ->
    (
# 33 "parser/parser.mly"
                                                      ( LetIn (x, e1, e2) )
# 203 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_06 =
  fun x ->
    (
# 34 "parser/parser.mly"
                                            ( Call (x, []) )
# 211 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_07 =
  fun elst x ->
    (
# 35 "parser/parser.mly"
                                                           ( Call (x, elst) )
# 219 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_08 =
  fun x ->
    (
# 36 "parser/parser.mly"
         ( Id x )
# 227 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_09 =
  fun e1 e2 ->
    (
# 37 "parser/parser.mly"
                         ( Add (e1, e2) )
# 235 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_10 =
  fun e1 e2 ->
    (
# 38 "parser/parser.mly"
                                     ( Sub (e1, e2) )
# 243 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_11 =
  fun n ->
    (
# 39 "parser/parser.mly"
             ( Num n )
# 251 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_12 =
  fun e ->
    (
# 40 "parser/parser.mly"
                     ( Sub (Num 0, e))
# 259 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_13 =
  fun e ->
    (
# 41 "parser/parser.mly"
                 ( e )
# 267 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_14 =
  fun e ->
    (
# 44 "parser/parser.mly"
           ( [e] )
# 275 "parser/parser.ml"
     : (Ast.expr list))

let _menhir_action_15 =
  fun e elst ->
    (
# 45 "parser/parser.mly"
                                ( e :: elst )
# 283 "parser/parser.ml"
     : (Ast.expr list))

let _menhir_action_16 =
  fun e ->
    (
# 48 "parser/parser.mly"
                                              ( e )
# 291 "parser/parser.ml"
     : (Ast.expr))

let _menhir_action_17 =
  fun e ->
    (
# 17 "parser/parser.mly"
               ( Prog ([], e) )
# 299 "parser/parser.ml"
     : (Ast.prog))

let _menhir_action_18 =
  fun dlst e ->
    (
# 18 "parser/parser.mly"
                              ( Prog (dlst, e) )
# 307 "parser/parser.ml"
     : (Ast.prog))

let _menhir_action_19 =
  fun x ->
    (
# 29 "parser/parser.mly"
         ( [x] )
# 315 "parser/parser.ml"
     : (string list))

let _menhir_action_20 =
  fun vlst x ->
    (
# 30 "parser/parser.mly"
                       ( x :: vlst )
# 323 "parser/parser.ml"
     : (string list))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | COMMA ->
        "COMMA"
    | EOF ->
        "EOF"
    | EQ ->
        "EQ"
    | ID _ ->
        "ID"
    | KW_DEF ->
        "KW_DEF"
    | KW_ENDEF ->
        "KW_ENDEF"
    | KW_IN ->
        "KW_IN"
    | KW_LET ->
        "KW_LET"
    | LEFT_PARENTHESIS ->
        "LEFT_PARENTHESIS"
    | MINUS ->
        "MINUS"
    | NEG ->
        "NEG"
    | NUMBER _ ->
        "NUMBER"
    | PLUS ->
        "PLUS"
    | RIGHT_PARENTHESIS ->
        "RIGHT_PARENTHESIS"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37-39"]
  
  let rec _menhir_goto_parse : type  ttv_stack. ttv_stack -> _ -> _menhir_box_parse =
    fun _menhir_stack _v ->
      MenhirBox_parse _v
  
  let rec _menhir_run_38 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOF ->
          let e = _v in
          let _v = _menhir_action_17 e in
          _menhir_goto_parse _menhir_stack _v
      | _ ->
          _eRR ()
  
  and _menhir_run_14 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_11 n in
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | NEG ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState14
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState14
      | KW_LET ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState14
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState14
      | _ ->
          _eRR ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_09 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState40 ->
          _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState00 ->
          _menhir_run_38 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState34 ->
          _menhir_run_35 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState30 ->
          _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState03 ->
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState21 ->
          _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState16 ->
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState14 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState18 ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState08 ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_41 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_decl_list as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | EOF ->
          let MenhirCell1_decl_list (_menhir_stack, _, dlst) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_18 dlst e in
          _menhir_goto_parse _menhir_stack _v
      | _ ->
          _eRR ()
  
  and _menhir_run_16 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_11 n in
          _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | NEG ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState16
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState16
      | KW_LET ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState16
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState16
      | _ ->
          _eRR ()
  
  and _menhir_run_17 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e1) = _menhir_stack in
      let e2 = _v in
      let _v = _menhir_action_10 e1 e2 in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_02 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_NEG (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState02
      | _ ->
          _eRR ()
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_PARENTHESIS (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_11 n in
          _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState03 _tok
      | NEG ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
      | KW_LET ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState03
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState03
      | _ ->
          _eRR ()
  
  and _menhir_run_23 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_LEFT_PARENTHESIS as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | RIGHT_PARENTHESIS ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LEFT_PARENTHESIS (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_16 e in
          _menhir_goto_paren_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | _ ->
          _eRR ()
  
  and _menhir_goto_paren_expr : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState02 ->
          _menhir_run_25 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState40 ->
          _menhir_run_10_spec_40 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState00 ->
          _menhir_run_10_spec_00 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState34 ->
          _menhir_run_10_spec_34 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState30 ->
          _menhir_run_10_spec_30 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState03 ->
          _menhir_run_10_spec_03 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState21 ->
          _menhir_run_10_spec_21 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState06 ->
          _menhir_run_10_spec_06 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState18 ->
          _menhir_run_10_spec_18 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState16 ->
          _menhir_run_10_spec_16 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState14 ->
          _menhir_run_10_spec_14 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState08 ->
          _menhir_run_10_spec_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_25 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_NEG -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_NEG (_menhir_stack, _menhir_s) = _menhir_stack in
      let e = _v in
      let _v = _menhir_action_12 e in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_10_spec_40 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_decl_list -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState40 _tok
  
  and _menhir_run_10_spec_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_38 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState00 _tok
  
  and _menhir_run_10_spec_34 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_var_list -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_35 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState34 _tok
  
  and _menhir_run_35 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_var_list as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | KW_ENDEF ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_var_list (_menhir_stack, _, vlst) = _menhir_stack in
          let MenhirCell0_ID (_menhir_stack, x) = _menhir_stack in
          let MenhirCell1_KW_DEF (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_02 e vlst x in
          _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_decl : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | KW_DEF ->
          let _menhir_stack = MenhirCell1_decl (_menhir_stack, _menhir_s, _v) in
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState43
      | ID _ | KW_LET | LEFT_PARENTHESIS | NEG | NUMBER _ ->
          let d = _v in
          let _v = _menhir_action_03 d in
          _menhir_goto_decl_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_26 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_KW_DEF (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          let _menhir_stack = MenhirCell0_ID (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | ID _v_0 ->
              _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState27
          | EQ ->
              let _menhir_stack = MenhirCell1_EQ (_menhir_stack, MenhirState27) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NUMBER _v_1 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let n = _v_1 in
                  let _v = _menhir_action_11 n in
                  _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState30 _tok
              | NEG ->
                  _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState30
              | LEFT_PARENTHESIS ->
                  _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState30
              | KW_LET ->
                  _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState30
              | ID _v_3 ->
                  _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_3 MenhirState30
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_28 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v_0 ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
          _menhir_run_28 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState28
      | EQ ->
          let x = _v in
          let _v = _menhir_action_19 x in
          _menhir_goto_var_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_var_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState27 ->
          _menhir_run_33 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState28 ->
          _menhir_run_29 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_33 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_var_list (_menhir_stack, _menhir_s, _v) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUMBER _v_0 ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v_0 in
          let _v = _menhir_action_11 n in
          _menhir_run_35 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState34 _tok
      | NEG ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState34
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState34
      | KW_LET ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState34
      | ID _v_2 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState34
      | _ ->
          _eRR ()
  
  and _menhir_run_04 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_KW_LET (_menhir_stack, _menhir_s) in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          let _menhir_stack = MenhirCell0_ID (_menhir_stack, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | EQ ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              (match (_tok : MenhirBasics.token) with
              | NUMBER _v_0 ->
                  let _tok = _menhir_lexer _menhir_lexbuf in
                  let n = _v_0 in
                  let _v = _menhir_action_11 n in
                  _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
              | NEG ->
                  _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
              | LEFT_PARENTHESIS ->
                  _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
              | KW_LET ->
                  _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState06
              | ID _v_2 ->
                  _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState06
              | _ ->
                  _eRR ())
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_20 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_LET _menhir_cell0_ID as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | KW_IN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUMBER _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let n = _v_0 in
              let _v = _menhir_action_11 n in
              _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState21 _tok
          | NEG ->
              _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState21
          | LEFT_PARENTHESIS ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState21
          | KW_LET ->
              _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState21
          | ID _v_2 ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState21
          | _ ->
              _eRR ())
      | _ ->
          _eRR ()
  
  and _menhir_run_22 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_LET _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_expr as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA | EOF | KW_ENDEF | KW_IN | RIGHT_PARENTHESIS ->
          let MenhirCell1_expr (_menhir_stack, _, e1) = _menhir_stack in
          let MenhirCell0_ID (_menhir_stack, x) = _menhir_stack in
          let MenhirCell1_KW_LET (_menhir_stack, _menhir_s) = _menhir_stack in
          let e2 = _v in
          let _v = _menhir_action_05 e1 e2 x in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_07 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LEFT_PARENTHESIS ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | RIGHT_PARENTHESIS ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let x = _v in
              let _v = _menhir_action_06 x in
              _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
          | NUMBER _v_0 ->
              let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
              let _tok = _menhir_lexer _menhir_lexbuf in
              let n = _v_0 in
              let _v = _menhir_action_11 n in
              _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState08 _tok
          | NEG ->
              let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
              _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState08
          | LEFT_PARENTHESIS ->
              let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState08
          | KW_LET ->
              let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
              _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState08
          | ID _v_2 ->
              let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState08
          | _ ->
              _eRR ())
      | COMMA | EOF | KW_ENDEF | KW_IN | MINUS | PLUS | RIGHT_PARENTHESIS ->
          let x = _v in
          let _v = _menhir_action_08 x in
          _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_13 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | COMMA ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          let _tok = _menhir_lexer _menhir_lexbuf in
          (match (_tok : MenhirBasics.token) with
          | NUMBER _v_0 ->
              let _tok = _menhir_lexer _menhir_lexbuf in
              let n = _v_0 in
              let _v = _menhir_action_11 n in
              _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState18 _tok
          | NEG ->
              _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState18
          | LEFT_PARENTHESIS ->
              _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState18
          | KW_LET ->
              _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState18
          | ID _v_2 ->
              _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState18
          | _ ->
              _eRR ())
      | RIGHT_PARENTHESIS ->
          let e = _v in
          let _v = _menhir_action_14 e in
          _menhir_goto_expr_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_expr_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState18 ->
          _menhir_run_19 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | MenhirState08 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_19 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_expr (_menhir_stack, _menhir_s, e) = _menhir_stack in
      let elst = _v in
      let _v = _menhir_action_15 e elst in
      _menhir_goto_expr_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_11 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let MenhirCell1_ID (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let elst = _v in
      let _v = _menhir_action_07 elst x in
      _menhir_goto_expr _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_29 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_ID (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let vlst = _v in
      let _v = _menhir_action_20 vlst x in
      _menhir_goto_var_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  and _menhir_run_31 : type  ttv_stack. (((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_EQ as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match (_tok : MenhirBasics.token) with
      | PLUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_14 _menhir_stack _menhir_lexbuf _menhir_lexer
      | MINUS ->
          let _menhir_stack = MenhirCell1_expr (_menhir_stack, _menhir_s, _v) in
          _menhir_run_16 _menhir_stack _menhir_lexbuf _menhir_lexer
      | KW_ENDEF ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_EQ (_menhir_stack, _) = _menhir_stack in
          let MenhirCell0_ID (_menhir_stack, x) = _menhir_stack in
          let MenhirCell1_KW_DEF (_menhir_stack, _menhir_s) = _menhir_stack in
          let e = _v in
          let _v = _menhir_action_01 e x in
          _menhir_goto_decl _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_goto_decl_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState43 ->
          _menhir_run_44 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState00 ->
          _menhir_run_40 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_44 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_decl -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_decl (_menhir_stack, _menhir_s, d) = _menhir_stack in
      let dlst = _v in
      let _v = _menhir_action_04 d dlst in
      _menhir_goto_decl_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_40 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_decl_list (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | NUMBER _v_0 ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v_0 in
          let _v = _menhir_action_11 n in
          _menhir_run_41 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState40 _tok
      | NEG ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState40
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState40
      | KW_LET ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState40
      | ID _v_2 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 MenhirState40
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_10_spec_30 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_DEF _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_EQ -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_31 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState30 _tok
  
  and _menhir_run_10_spec_03 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_LEFT_PARENTHESIS -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_23 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState03 _tok
  
  and _menhir_run_10_spec_21 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_LET _menhir_cell0_ID, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_22 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState21 _tok
  
  and _menhir_run_10_spec_06 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_KW_LET _menhir_cell0_ID -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_20 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState06 _tok
  
  and _menhir_run_10_spec_18 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState18 _tok
  
  and _menhir_run_10_spec_16 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_17 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_10_spec_14 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_expr -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
  
  and _menhir_run_10_spec_08 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_ID -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let e = _v in
      let _v = _menhir_action_13 e in
      _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState08 _tok
  
  let rec _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | NUMBER _v ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let n = _v in
          let _v = _menhir_action_11 n in
          _menhir_run_38 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState00 _tok
      | NEG ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | LEFT_PARENTHESIS ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | KW_LET ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | KW_DEF ->
          _menhir_run_26 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState00
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v MenhirState00
      | _ ->
          _eRR ()
  
end

let parse =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_parse v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
