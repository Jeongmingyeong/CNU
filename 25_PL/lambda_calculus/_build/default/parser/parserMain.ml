let parse (s: string) : Ast.t =
  let lbuf = Lexing.from_string s in
  Parser.parse Lexer.read lbuf

