{
  open Parser

  exception LexingError of string
}

(* Decimal number *)
let pos_digit = ['1'-'9']
let digit = ['0'-'9']
let pos_number = pos_digit digit*
let number = "0" | pos_number | '-' pos_number

(* Identifier *)
let id = ['a'-'z''A'-'Z''_']*

(* White space *)
let ws = [' ''\t''\n']*

rule read = 
  parse
  (* encoding 될 수 있는 값 *)
  | "tru" { CONST "tru" }
  | "fls" { CONST "fls" }
  | "test" { CONST "test" }
  | "and" { CONST "and" }
  | "or" { CONST "or" }
  | "not" { CONST "not" }
  | "pair" { CONST "pair" }
  | "fst" { CONST "fst" }
  | "snd" { CONST "snd" }
  | "add" { CONST "add" }
  | "times" { CONST "times" }
  | "isZero" { CONST "isZero" }
  | "zz" { CONST "zz" }
  | "ss" { CONST "ss" }
  | "pred" { CONST "pred" }
  | "sub" { CONST "sub" }
  | "eq" { CONST "eq" }
  | number as n { CONST n }


  | "lambda" { KW_LAMBDA }
  | "->" { ARROW }
  | "(" { LEFT_PAREN }
  | ")" { RIGHT_PAREN }
  | id as i { ID i }
  | ws { read lexbuf }
  | eof { EOF }
  | _ { raise (LexingError ("Unexpected character: " ^ Lexing.lexeme lexbuf)) }
