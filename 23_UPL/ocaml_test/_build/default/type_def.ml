type number =
  | Zero
  | Integer of int
  | Real of float

type num =
  | Zero
  | Int of int
  | Float of float

let _ =
	let x : number = Zero in
	let y : num = Zero in
	let z = Zero in
	let _ = print_number(x) in
	let _ = print_num(y) in
	print_num(z)
