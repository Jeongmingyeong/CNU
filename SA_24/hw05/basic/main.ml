let start_symbol = "<start>"

(* 실행 후 결과 가져오는 function *)
let run_command cmd inp = 
  let args = [| cmd; inp |] in
  let ic = Unix.open_process_args_in cmd args in
  (* let ic = Unix.open_process_in cmd in *)
  let output = ref "" in
  try
    while true do
      output := !output ^ input_line ic ^ "\n"
    done;
    !output
  with End_of_file ->
    let _ = Unix.close_process_in ic in
    !output

(* replace "\n" to " " *)
let rep_new_line (r: string) : string =
  String.fold_left (fun res c -> if (c = '\n') then res ^ " " else res ^ (String.make 1 c)) "" r

(* command 실행 결과에서 정보 가져오는 함수: "output:" or "Crash!:" *)
let get_print_info (print_res : string) : string =
  let split_str = rep_new_line print_res |> String.split_on_char ' ' |> List.filter (fun s -> s <> "\t") in
  let output_or_crash = List.nth split_str 2 in
  output_or_crash

let () =
  Random.self_init (); (* setting random seed *)
  let rec run () =
    let _ = Grammer.init_eh () in
    let input_string = Fuzzer.fuzzer start_symbol in
    let msg = run_command "./a.out" input_string in 
    let result = get_print_info msg in
    if result = "Crash!:" then 
      let _ = Format.printf "%s@." msg in (* print message *)
      let cp = Grammer.EhPairSet.cardinal (Grammer.get_eh()) in
      let tp = Grammer.total_pair in
      let _ = Format.printf "choose pair: %d | total pair: %d@." cp tp in
      Format.printf "Grammer coverage: %.2f@." ((float_of_int cp) /. (float_of_int tp))
    else run ()
  in run ()
