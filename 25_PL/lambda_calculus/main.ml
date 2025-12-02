module F = Format

let _ = 
  if (Array.length Sys.argv) < 3 then 
      let _ = F.printf "=== usage ===@." in
      let _ = F.printf "dune exec ./main.exe \"term\" [value|name]@." in
      exit 1
  else
    let s : string = Sys.argv.(1) in
    let reduction : string = Sys.argv.(2) in
    let func, lst =
      if reduction = "value" then 
        let f = Derivation_call_by_value.start in
        let l = Derivation_call_by_value.result in
        f, l
      else if reduction = "name" then 
        let f = Derivation_call_by_name.start in
        let l = Derivation_call_by_name.result in
        f, l
      else 
        let _ = F.printf "reduction option : value or name" in
      exit 1
    in
    let res : Ast.t = ParserMain.parse s |> func in
    Print_step.print !lst


