module F = Format

let _ =
  let x = 0 in
  let y = 1 in
  let rec fib i =
    match i with
	| x -> 0
	| y -> 1
	| z -> fib (z-2) + fib (z-1)
  in
  F.printf "Res: %d\n" (fib 7)
