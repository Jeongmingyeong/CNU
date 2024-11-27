let grammer: (string * (string list)) list = [
  ("<start>", ["<string>"]);
  ("<string>", ["<letter>"; "<letter><string>"]);
  ("<letter>", ["<plus>"; "<percent>"; "<other>"]);
  ("<plus>", ["+"]);
  ("<percent>", ["%<hexdigit><hexdigit>"]);
  ("<hexdigit>", ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"]);
  ("<other>", ["0"; "1"; "2"; "3"; "4"; "5"; "6"; "7"; "8"; "9"; "a"; "b"; "c"; "d"; "e"; "f"])
]

(* find values mapping from key *)
let values (key: string) : string list = List.assoc key grammer
