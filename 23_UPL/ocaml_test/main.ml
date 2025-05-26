module F = Format
module H = Hw06 

(*
let x = 3 in (* 왜 여기서 syntax error 발생할까? *)
F.printf "%d\n" x
*)

let _ =
  let app f x = f x in
  let inc x = x + 1 in
  let dec x = x - 1 in
  let _ = F.printf "Inc: %d\n" (app inc 3) in
  F.printf "Dec: %d\n" (app dec 3)
