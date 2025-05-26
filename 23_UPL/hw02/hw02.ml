let ls = [1; 2; 3] in
let ls' = List.map (fun a -> a + 5) ls in
let _ = List.iter (fun a -> Format.printf "%d@." a) ls in
List.iter (fun a -> Format.printf "%d@." a) ls'

