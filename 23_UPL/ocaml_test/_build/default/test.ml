let z = 10 (* [z, 10] *)
let f x = x + z

let _ =
  let y = 3 in
  let w = 4 in
  let h = w - y in
  Format.printf "%d\n" (f h)

(* let _ = 
  let v = 5 in
  Format.printf "%d\n" (f v) *)