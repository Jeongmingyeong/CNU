exception Parse_error of string * Lexing.position

(* 기존 Lexer.read를 감싸서 로그를 찍는 함수 *)
let read_with_log lexbuf =
  let tok =
    try Lexer.read lexbuf
    with Lexer.LexingError msg ->
      let pos = lexbuf.Lexing.lex_curr_p in
      Printf.eprintf "Lexing error at line %d, col %d: %s\n"
        pos.Lexing.pos_lnum
        (pos.Lexing.pos_cnum - pos.Lexing.pos_bol)
        msg;
      raise (Lexer.LexingError msg)
  in
  let pos = lexbuf.Lexing.lex_curr_p in
  Printf.printf "Token read at line %d, col %d\n"
    pos.Lexing.pos_lnum
    (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
  tok

let test_lex s =
  let lexbuf = Lexing.from_string s in
  let rec loop () =
    match Lexer.read lexbuf with
    | EOF -> []
    | tok -> tok :: loop ()
  in
  loop ()

let test_lex_file (file: string) =
  let ic = open_in file in
  let len = in_channel_length ic in
  let s : string = really_input_string ic len in
  close_in ic;
  test_lex s

let parse (s: string) : Ast.prog =
  let lexbuf = Lexing.from_string s in
  try
    Parser.parse read_with_log lexbuf
  with
  | _ ->
      let pos = lexbuf.Lexing.lex_curr_p in
      Printf.eprintf "Syntax error at line %d, col %d\n"
        pos.Lexing.pos_lnum
        (pos.Lexing.pos_cnum - pos.Lexing.pos_bol);
      raise (Parse_error ("Syntax error", pos))

let parse_file (file: string) : Ast.prog =
  let ic = open_in file in
  let len = in_channel_length ic in
  let s : string = really_input_string ic len in
  close_in ic;
  parse s


