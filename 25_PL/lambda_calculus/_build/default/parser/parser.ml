
module MenhirBasics = struct
  
  exception Error
  
  let _eRR =
    fun _s ->
      raise Error
  
  type token = 
    | RIGHT_PAREN
    | LEFT_PAREN
    | KW_LAMBDA
    | ID of (
# 5 "parser/parser.mly"
       (string)
# 18 "parser/parser.ml"
  )
    | EOF
    | CONST of (
# 6 "parser/parser.mly"
       (string)
# 24 "parser/parser.ml"
  )
    | ARROW
  
end

include MenhirBasics

# 1 "parser/parser.mly"
  
  open Ast

# 36 "parser/parser.ml"

type ('s, 'r) _menhir_state = 
  | MenhirState00 : ('s, _menhir_box_parse) _menhir_state
    (** State 00.
        Stack shape : .
        Start symbol: parse. *)

  | MenhirState01 : (('s, _menhir_box_parse) _menhir_cell1_LEFT_PAREN, _menhir_box_parse) _menhir_state
    (** State 01.
        Stack shape : LEFT_PAREN.
        Start symbol: parse. *)

  | MenhirState02 : (('s, _menhir_box_parse) _menhir_cell1_KW_LAMBDA, _menhir_box_parse) _menhir_state
    (** State 02.
        Stack shape : KW_LAMBDA.
        Start symbol: parse. *)

  | MenhirState03 : (('s, _menhir_box_parse) _menhir_cell1_ID, _menhir_box_parse) _menhir_state
    (** State 03.
        Stack shape : ID.
        Start symbol: parse. *)

  | MenhirState06 : ((('s, _menhir_box_parse) _menhir_cell1_KW_LAMBDA, _menhir_box_parse) _menhir_cell1_var_list, _menhir_box_parse) _menhir_state
    (** State 06.
        Stack shape : KW_LAMBDA var_list.
        Start symbol: parse. *)

  | MenhirState10 : (('s, _menhir_box_parse) _menhir_cell1_atom, _menhir_box_parse) _menhir_state
    (** State 10.
        Stack shape : atom.
        Start symbol: parse. *)

  | MenhirState12 : ((('s, _menhir_box_parse) _menhir_cell1_atom, _menhir_box_parse) _menhir_cell1_atom, _menhir_box_parse) _menhir_state
    (** State 12.
        Stack shape : atom atom.
        Start symbol: parse. *)


and ('s, 'r) _menhir_cell1_atom = 
  | MenhirCell1_atom of 's * ('s, 'r) _menhir_state * (Ast.t)

and ('s, 'r) _menhir_cell1_var_list = 
  | MenhirCell1_var_list of 's * ('s, 'r) _menhir_state * (string list)

and ('s, 'r) _menhir_cell1_ID = 
  | MenhirCell1_ID of 's * ('s, 'r) _menhir_state * (
# 5 "parser/parser.mly"
       (string)
# 85 "parser/parser.ml"
)

and ('s, 'r) _menhir_cell1_KW_LAMBDA = 
  | MenhirCell1_KW_LAMBDA of 's * ('s, 'r) _menhir_state

and ('s, 'r) _menhir_cell1_LEFT_PAREN = 
  | MenhirCell1_LEFT_PAREN of 's * ('s, 'r) _menhir_state

and _menhir_box_parse = 
  | MenhirBox_parse of (Ast.t) [@@unboxed]

let _menhir_action_01 =
  fun t ts ->
    (
# 24 "parser/parser.mly"
                        ( List.fold_left (fun acc arg -> App (acc, arg)) t ts )
# 102 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_02 =
  fun x ->
    (
# 33 "parser/parser.mly"
         ( Var x )
# 110 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_03 =
  fun cx ->
    (
# 34 "parser/parser.mly"
             ( ChurchConst cx )
# 118 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_04 =
  fun body vl ->
    (
# 35 "parser/parser.mly"
                                          (
      List.fold_right (fun x acc -> LambdaAbs (x, acc)) vl body
    )
# 128 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_05 =
  fun t ->
    (
# 38 "parser/parser.mly"
                                  ( t )
# 136 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_06 =
  fun () ->
    (
# 28 "parser/parser.mly"
     ( [] )
# 144 "parser/parser.ml"
     : (Ast.t list))

let _menhir_action_07 =
  fun t tl ->
    (
# 29 "parser/parser.mly"
                        ( t :: tl )
# 152 "parser/parser.ml"
     : (Ast.t list))

let _menhir_action_08 =
  fun t ->
    (
# 16 "parser/parser.mly"
               ( t )
# 160 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_09 =
  fun t ->
    (
# 20 "parser/parser.mly"
               ( t )
# 168 "parser/parser.ml"
     : (Ast.t))

let _menhir_action_10 =
  fun x ->
    (
# 42 "parser/parser.mly"
         ( [x] )
# 176 "parser/parser.ml"
     : (string list))

let _menhir_action_11 =
  fun vl x ->
    (
# 43 "parser/parser.mly"
                     ( x :: vl )
# 184 "parser/parser.ml"
     : (string list))

let _menhir_print_token : token -> string =
  fun _tok ->
    match _tok with
    | ARROW ->
        "ARROW"
    | CONST _ ->
        "CONST"
    | EOF ->
        "EOF"
    | ID _ ->
        "ID"
    | KW_LAMBDA ->
        "KW_LAMBDA"
    | LEFT_PAREN ->
        "LEFT_PAREN"
    | RIGHT_PAREN ->
        "RIGHT_PAREN"

let _menhir_fail : unit -> 'a =
  fun () ->
    Printf.eprintf "Internal failure -- please contact the parser generator's developers.\n%!";
    assert false

include struct
  
  [@@@ocaml.warning "-4-37"]
  
  let _menhir_run_17 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _v _tok ->
      match (_tok : MenhirBasics.token) with
      | EOF ->
          let t = _v in
          let _v = _menhir_action_08 t in
          MenhirBox_parse _v
      | _ ->
          _eRR ()
  
  let rec _menhir_run_01 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_LEFT_PAREN (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState01 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LEFT_PAREN ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | KW_LAMBDA ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | CONST _v ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_02 : type  ttv_stack. ttv_stack -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s ->
      let _menhir_stack = MenhirCell1_KW_LAMBDA (_menhir_stack, _menhir_s) in
      let _menhir_s = MenhirState02 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v ->
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_03 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | ID _v_0 ->
          let _menhir_stack = MenhirCell1_ID (_menhir_stack, _menhir_s, _v) in
          _menhir_run_03 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState03
      | ARROW ->
          let x = _v in
          let _v = _menhir_action_10 x in
          _menhir_goto_var_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_goto_var_list : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      match _menhir_s with
      | MenhirState02 ->
          _menhir_run_05 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | MenhirState03 ->
          _menhir_run_04 _menhir_stack _menhir_lexbuf _menhir_lexer _v
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_05 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_LAMBDA as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _menhir_stack = MenhirCell1_var_list (_menhir_stack, _menhir_s, _v) in
      let _menhir_s = MenhirState06 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LEFT_PAREN ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | KW_LAMBDA ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | CONST _v ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
  and _menhir_run_07 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let x = _v in
      let _v = _menhir_action_02 x in
      _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_atom : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState12 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState10 ->
          _menhir_run_12 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState00 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState01 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | MenhirState06 ->
          _menhir_run_10 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_12 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_atom as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | LEFT_PAREN ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState12
      | KW_LAMBDA ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState12
      | ID _v_0 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState12
      | CONST _v_1 ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState12
      | EOF | RIGHT_PAREN ->
          let _v_2 = _menhir_action_06 () in
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_08 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s ->
      let _tok = _menhir_lexer _menhir_lexbuf in
      let cx = _v in
      let _v = _menhir_action_03 cx in
      _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_13 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_atom, _menhir_box_parse) _menhir_cell1_atom -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_atom (_menhir_stack, _menhir_s, t) = _menhir_stack in
      let tl = _v in
      let _v = _menhir_action_07 t tl in
      _menhir_goto_atom_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_atom_list : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_atom as 'stack) -> _ -> _ -> _ -> ('stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState12 ->
          _menhir_run_13 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState10 ->
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_11 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_atom -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_atom (_menhir_stack, _menhir_s, t) = _menhir_stack in
      let ts = _v in
      let _v = _menhir_action_01 t ts in
      let t = _v in
      let _v = _menhir_action_09 t in
      _menhir_goto_term _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_goto_term : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      match _menhir_s with
      | MenhirState00 ->
          _menhir_run_17 _menhir_stack _v _tok
      | MenhirState01 ->
          _menhir_run_15 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | MenhirState06 ->
          _menhir_run_09 _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok
      | _ ->
          _menhir_fail ()
  
  and _menhir_run_15 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_LEFT_PAREN -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      match (_tok : MenhirBasics.token) with
      | RIGHT_PAREN ->
          let _tok = _menhir_lexer _menhir_lexbuf in
          let MenhirCell1_LEFT_PAREN (_menhir_stack, _menhir_s) = _menhir_stack in
          let t = _v in
          let _v = _menhir_action_05 t in
          _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_09 : type  ttv_stack. ((ttv_stack, _menhir_box_parse) _menhir_cell1_KW_LAMBDA, _menhir_box_parse) _menhir_cell1_var_list -> _ -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _tok ->
      let MenhirCell1_var_list (_menhir_stack, _, vl) = _menhir_stack in
      let MenhirCell1_KW_LAMBDA (_menhir_stack, _menhir_s) = _menhir_stack in
      let body = _v in
      let _v = _menhir_action_04 body vl in
      _menhir_goto_atom _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok
  
  and _menhir_run_10 : type  ttv_stack. ttv_stack -> _ -> _ -> _ -> (ttv_stack, _menhir_box_parse) _menhir_state -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s _tok ->
      let _menhir_stack = MenhirCell1_atom (_menhir_stack, _menhir_s, _v) in
      match (_tok : MenhirBasics.token) with
      | LEFT_PAREN ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState10
      | KW_LAMBDA ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer MenhirState10
      | ID _v_0 ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v_0 MenhirState10
      | CONST _v_1 ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v_1 MenhirState10
      | EOF | RIGHT_PAREN ->
          let _v_2 = _menhir_action_06 () in
          _menhir_run_11 _menhir_stack _menhir_lexbuf _menhir_lexer _v_2 _tok
      | _ ->
          _eRR ()
  
  and _menhir_run_04 : type  ttv_stack. (ttv_stack, _menhir_box_parse) _menhir_cell1_ID -> _ -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer _v ->
      let MenhirCell1_ID (_menhir_stack, _menhir_s, x) = _menhir_stack in
      let vl = _v in
      let _v = _menhir_action_11 vl x in
      _menhir_goto_var_list _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
  
  let _menhir_run_00 : type  ttv_stack. ttv_stack -> _ -> _ -> _menhir_box_parse =
    fun _menhir_stack _menhir_lexbuf _menhir_lexer ->
      let _menhir_s = MenhirState00 in
      let _tok = _menhir_lexer _menhir_lexbuf in
      match (_tok : MenhirBasics.token) with
      | LEFT_PAREN ->
          _menhir_run_01 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | KW_LAMBDA ->
          _menhir_run_02 _menhir_stack _menhir_lexbuf _menhir_lexer _menhir_s
      | ID _v ->
          _menhir_run_07 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | CONST _v ->
          _menhir_run_08 _menhir_stack _menhir_lexbuf _menhir_lexer _v _menhir_s
      | _ ->
          _eRR ()
  
end

let parse =
  fun _menhir_lexer _menhir_lexbuf ->
    let _menhir_stack = () in
    let MenhirBox_parse v = _menhir_run_00 _menhir_stack _menhir_lexbuf _menhir_lexer in
    v
