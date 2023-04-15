module F = Format

let _ =
	let fib i =
		match i with
		| _ -> 0
	in F.printf "Res : %d\n" (fib 7)
