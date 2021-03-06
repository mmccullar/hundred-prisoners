type context = { has_lit: bool; count: int }

type result =
  | Released of int
  | Executed of int
                  
(* What happens when a prisoner visits the room *)
let visit_room prisoner days light context =
    (* do something and return the new value for light,
     * the context, and whether you wish to assert *)
    (light, context, false);;

Random.self_init();;

(* Verify that everyone has visited *)
let rec check_visited has_visited n =
    if n == 0 then
        Array.get has_visited n
    else if Array.get has_visited n then
        check_visited has_visited (n-1)
    else
        false;;

let make_context = { has_lit=false; count=0 }

let rec make_contexts n =
    if n == 0 then
        []
    else
        make_context :: make_contexts (n-1);;

let warden num_prisoners =
    (* Initialize the state of the world *)
    let prisoners = Array.of_list (make_contexts num_prisoners) in
    let has_visited = Array.make num_prisoners false in

    let rec warden_loop day light  =
        (* Choose a random prisoner *)
        let prisoner = Int32.to_int (Random.int32 (Int32.of_int num_prisoners)) in

        Array.set has_visited prisoner true;

        let prisoner_ctx = Array.get prisoners prisoner in
        let (new_light, new_prisoner_ctx, did_assert) =
            visit_room prisoner day light prisoner_ctx in
        Array.set prisoners prisoner new_prisoner_ctx;

        (* If the prisoner asserted that everyone has been there, check it *)
        if did_assert then
            if check_visited has_visited 100 then
                Released day
            else
                Executed day
        else
            warden_loop (day+1) new_light
    in
    warden_loop 0 false

let run_test num_prisoners =
  match warden num_prisoners with
  | Released num -> Printf.printf "Prisoners were released after %d days\n" num
  | Executed num -> Printf.printf "Prisoners were executed after %d days\n" num;;
