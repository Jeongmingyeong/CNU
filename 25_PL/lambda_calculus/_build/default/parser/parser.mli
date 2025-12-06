
(* The type of tokens. *)

type token = 
  | RIGHT_PAREN
  | LEFT_PAREN
  | KW_LAMBDA
  | ID of (string)
  | EOF
  | CONST of (string)
  | ARROW

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val parse: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.t)
