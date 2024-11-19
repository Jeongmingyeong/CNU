let trials = 100
let run_result = []
module S = Set.Make(String)
let crash_set = ref S.empty 

(* let get_result (s: string) : string = *)

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

(* #Test -> crash input list(acc) -> crash input list(result) *)
let rec run (f: string) (tryc: int) (res_ls: string list) : string list = 
  (* 1. create initial input *)
  let input = 
    if f = "crash" then Crash_fuzzer.gen_input ()
    else Fuzzer.random_string "" 
  in
  let rec inner_run (in_str: string) (ls: string list) : string list =
    (* 2. execute with input argument *)
    (* Format.printf "input str: %s@." in_str; *)
    let res = run_command "./a.out" in_str in
    (* 3. check crash or not *)
    (* if crash => append crash list *)
    (* else => search crash answer *)
    match (Fuzzer.check_crash res) with
    | true -> Format.printf "Crash!!: %s@." in_str;
      let _ = crash_set := S.add in_str !crash_set in
      List.append ls [in_str]
      
    | false -> 
        (* 3-1. if not crash => search answer *)
        let neighbor_list = Fuzzer.neighbor_string in_str [] in
        let neighbor_dist = List.fold_left (fun acc s -> 
            let r = run_command "./a.out" s in
            let ds = Fuzzer.calc_dist r in
            List.append acc [(ds, s)]
          ) [] neighbor_list
        in 
        let new_str = Fuzzer.choose_new_str neighbor_dist in
        inner_run new_str ls
    in 
  let run_one_step = inner_run input res_ls in
  if ((List.length run_one_step) = tryc) then run_one_step
  else run f tryc run_one_step
  

(* set을 돌며 결과 file 에 작성 *)
let write_set_to_file (set : S.t) (filename : string) =
  let out_channel = open_out filename in
  try
    S.iter (fun s ->
      output_string out_channel (s ^ "\n")
    ) set;
    close_out out_channel
  with e ->
    close_out_noerr out_channel;
    raise e

let () =
  let f = Array.get Sys.argv 1 in (* fuzzing flag: normal or crash*) 
  let n = Array.get Sys.argv 2 |> int_of_string in (* #crash_inputs: 0 이상 숫자 *) 
  let _ = run f n [] |> List.iter (fun s -> Format.printf "%s@." s) in
  (* 최종 crash input을 file 에 작성 *)
  write_set_to_file !crash_set "crash_input_list.txt"

