
(* The type of tokens. *)

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
  | NUMBER of (int)
  | MINUS
  | LESSTHAN
  | LEFT_PARENTHESIS
  | LEFT_BRACE
  | IF
  | ID of (string)
  | GREATERTHAN
  | FALSE
  | EQ
  | EOF
  | ELSE
  | DEF
  | AND

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val parse: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Ast.prog)
