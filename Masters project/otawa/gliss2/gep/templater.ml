# 1 "templater.mll"
 

(** Templater allows to generate files from templates.
	This templates may contains special token that are replaced
	by values retrieved from a dictionnary.

	Basically, an expression "$(identifier)" is replaced by a text
	found in the dictionnary.

	Templates language support support conditional statement
	in form "$(if identifier) ... $(end)" or
	"$(if identifier) ... $(else) ... $(end)". The identifier is looked
	in the dictionnary and must be resolved as a boolean.

	Loops are allowed using "$(foreach identifier) ... $(end)". In this
	case, the identifier must be resolved to a collection and the loop body
	is generated as many times there is elements in the collection.
	Identifiers contained in the body are resolved against special
	dictionnaries associated with each collection element.

	Finally, notes that "$$" expression is reduceded to "$$".
	*)

exception Error of string

(** Current file. *)
let file = ref ""

(** Current line. *)
let line = ref 0

(** Raise a template error.
	@param msg	Error message. *)
let error msg =
	raise (Error (Printf.sprintf "%s:%d: %s" !file !line msg))

(** Fallback symbol to look if a text symbol is not found (TEXT or FUN). *)
let fallback_text = "!text"

(** Fallback symbol to look for if a collection symbol is not found (COLL or GEN_COLL). *)
let fallback_coll = "!coll"

(** Fallback symbol to look if isdef fail (BOOL or GEN_BOOL). *)
let fallback_ifdef = "!isdef"

(** Fallback symbol to evaluate a symbol that is not found (BOOL or GEN_BOOL). *)
let fallback_bool = "!bool"

(** Type of dictionnaries. *)
type dict_t = (string * value_t) list

(** Values of a dictionnary *)
and  value_t =
	  TEXT of (out_channel -> unit)						(** function called when identifier is found *)
	| COLL of ((dict_t -> unit) -> dict_t -> unit)		(** collection : argument function must be called for each element
															with a dictionnary fixed for the current element. *)
	| BOOL of (unit -> bool)							(** boolean value *)
	| FUN of (out_channel -> string -> unit)			(** function value *)
	| GEN_COLL of (string -> (dict_t -> unit) -> dict_t -> unit)
		(** collection : argument function must be called for each element with a dictionary fixed for the current element. *)
	| GEN_BOOL of (string -> bool)						(** generic boolean symbol *)


type state_t =
	| TOP
	| THEN
	| ELSE
	| FOREACH
	| WITH


(** Perform text evaluation (and function if any)
	@param out	Out channel.
	@param dict	Used dictionnary.
	@param id	Text identifier. *)
let do_text out dict id =
	let fail _ = raise (Error (Printf.sprintf "symbol \"%s\" cannot be found or has bad type" id)) in

	(* parse arguments *)
	let p =  try String.index id ':' with Not_found -> -1 in
	let id = if p == -1 then id else String.sub id 0 p in
	let args = if p == -1 then "" else (String.sub id (p + 1) ((String.length id) - p - 1)) in
		
	let lookup id args fb =
		try
			(match List.assoc id dict with
			| TEXT f -> f out
			| FUN f ->  f out args
			| _ -> fb ())
		with Not_found ->
			fb () in
	
	try
		lookup id args (fun _ -> lookup fallback_text id fail)
	with Not_found ->
		raise (Error (Printf.sprintf "uncaught Not_found in generation with \"%s\"" id))


(** Get a collection.
	@param dict	Dictionnary to look in.
	@param id	Identifier.
	@return		Found collection function. *)
let do_coll dict id =

	let lookup i f =
		try
			match List.assoc i dict with
			| COLL f -> f
			| GEN_COLL f -> (f id)
			| _ -> f ()
		with Not_found ->
			f () in

	lookup id
		(fun _ -> lookup fallback_coll
			(fun _ -> error (Printf.sprintf "\"%s\" is undefined or not a collection" id)))


(** Get a boolean value.
	@param dict		Dictionnary to look in.
	@param id		Identifier.
	@return			Boolean value. *)
let do_bool dict id =

	let lookup i f =
		try
			match List.assoc i dict with
			| BOOL f -> f ()
			| GEN_BOOL f -> f id
			| _ -> f ()
		with Not_found ->
			f () in

	lookup id
		(fun _ -> lookup fallback_bool
			(fun _ -> false))


(** Test if a definition is provided in the dictionary.
	@param dict		Dictionnary to look in.
	@param id		Identifier.
	@return			Boolean value. *)
let do_ifdef dict id =
	if List.mem_assoc id dict then true else
	try
		match List.assoc fallback_ifdef dict with
		| GEN_BOOL f -> f id
		| _ -> false
	with Not_found -> false

# 153 "templater.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base = 
   "\000\000\242\255\243\255\244\255\001\000\001\000\001\000\255\255\
    \002\000\003\000\004\000\005\000\008\000\246\255\009\000\010\000\
    \011\000\014\000\012\000\022\000\024\000\025\000\001\000\254\255\
    \017\000\018\000\029\000\030\000\051\000\002\000\253\255\023\000\
    \026\000\027\000\003\000\252\255\028\000\031\000\004\000\251\255\
    \066\000\032\000\033\000\068\000\086\000\108\000\005\000\112\000\
    \006\000\250\255\249\255\035\000\115\000\116\000\119\000\007\000\
    \248\255\038\000\039\000\122\000\126\000\127\000\008\000\247\255\
    \004\000\245\255\013\000\254\255\255\255\079\000\248\255\249\255\
    \250\255\042\000\041\000\255\255\042\000\002\000\019\000\031\000\
    \054\000\000\000\000\000\057\000\000\000\254\255\153\000\253\255\
    \049\000\065\000\040\000\009\000\252\255\068\000\043\000\010\000\
    \251\255\160\000\249\255\250\255\251\255\050\000\070\000\255\255\
    \063\000\072\000\066\000\064\000\078\000\083\000\082\000\078\000\
    \174\000\254\255\175\000\253\255\086\000\044\000\252\255";
  Lexing.lex_backtrk = 
   "\255\255\255\255\255\255\255\255\012\000\012\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\001\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\002\000\255\255\255\255\
    \255\255\255\255\003\000\255\255\255\255\255\255\004\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\006\000\255\255\
    \005\000\255\255\255\255\255\255\255\255\255\255\255\255\007\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\008\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\006\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\001\000\255\255\002\000\255\255\
    \255\255\255\255\255\255\003\000\255\255\255\255\255\255\004\000\
    \255\255\255\255\255\255\255\255\255\255\005\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255";
  Lexing.lex_default = 
   "\002\000\000\000\000\000\000\000\255\255\255\255\008\000\000\000\
    \008\000\008\000\008\000\008\000\008\000\000\000\008\000\008\000\
    \008\000\008\000\008\000\008\000\021\000\021\000\255\255\000\000\
    \008\000\008\000\008\000\028\000\028\000\255\255\000\000\008\000\
    \008\000\008\000\255\255\000\000\008\000\008\000\255\255\000\000\
    \008\000\008\000\008\000\044\000\044\000\047\000\255\255\047\000\
    \255\255\000\000\000\000\008\000\008\000\054\000\054\000\255\255\
    \000\000\008\000\008\000\008\000\061\000\061\000\255\255\000\000\
    \255\255\000\000\067\000\000\000\000\000\071\000\000\000\000\000\
    \000\000\255\255\255\255\000\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\000\000\255\255\000\000\
    \255\255\255\255\255\255\255\255\000\000\255\255\255\255\255\255\
    \000\000\099\000\000\000\000\000\000\000\255\255\255\255\000\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\255\255\000\000\255\255\255\255\000\000";
  Lexing.lex_trans = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\085\000\003\000\023\000\030\000\035\000\039\000\050\000\
    \049\000\056\000\063\000\092\000\096\000\000\000\000\000\068\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\020\000\
    \085\000\008\000\008\000\000\000\005\000\007\000\027\000\008\000\
    \065\000\006\000\255\255\013\000\013\000\013\000\013\000\004\000\
    \064\000\013\000\013\000\013\000\013\000\013\000\020\000\013\000\
    \008\000\008\000\013\000\013\000\008\000\027\000\008\000\013\000\
    \013\000\013\000\022\000\013\000\034\000\013\000\013\000\013\000\
    \038\000\013\000\013\000\043\000\013\000\008\000\075\000\013\000\
    \013\000\091\000\074\000\008\000\095\000\118\000\103\000\000\000\
    \000\000\072\000\102\000\000\000\029\000\000\000\000\000\008\000\
    \000\000\082\000\043\000\083\000\008\000\045\000\010\000\012\000\
    \086\000\040\000\009\000\013\000\017\000\013\000\024\000\016\000\
    \031\000\018\000\032\000\073\000\019\000\008\000\008\000\014\000\
    \011\000\008\000\026\000\015\000\053\000\008\000\033\000\046\000\
    \008\000\037\000\079\000\060\000\057\000\025\000\051\000\008\000\
    \008\000\052\000\036\000\058\000\008\000\059\000\076\000\078\000\
    \008\000\080\000\077\000\053\000\008\000\046\000\088\000\008\000\
    \089\000\048\000\060\000\081\000\013\000\013\000\008\000\008\000\
    \055\000\084\000\087\000\013\000\093\000\090\000\042\000\013\000\
    \062\000\094\000\100\000\104\000\106\000\116\000\114\000\105\000\
    \041\000\107\000\108\000\109\000\110\000\111\000\112\000\113\000\
    \115\000\087\000\117\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\101\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\113\000\115\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \001\000\255\255\255\255\255\255\255\255\255\255\000\000\000\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \000\000\255\255\255\255\000\000\000\000\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\000\000\255\255\000\000\000\000\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\255\255\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\000\000\255\255\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\070\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\255\255\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\255\255\000\000\000\000\000\000\
    \255\255\000\000\000\000\255\255\255\255\000\000\000\000\255\255\
    \000\000\000\000\255\255\000\000\000\000\000\000\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \098\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    ";
  Lexing.lex_check = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\084\000\000\000\022\000\029\000\034\000\038\000\046\000\
    \048\000\055\000\062\000\091\000\095\000\255\255\255\255\066\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\019\000\
    \084\000\020\000\021\000\255\255\000\000\005\000\026\000\027\000\
    \064\000\005\000\006\000\008\000\009\000\010\000\011\000\000\000\
    \004\000\012\000\014\000\015\000\016\000\018\000\019\000\017\000\
    \020\000\021\000\024\000\025\000\028\000\026\000\027\000\019\000\
    \031\000\020\000\021\000\032\000\033\000\036\000\026\000\027\000\
    \037\000\041\000\042\000\040\000\051\000\043\000\073\000\057\000\
    \058\000\090\000\073\000\028\000\094\000\117\000\101\000\255\255\
    \255\255\069\000\101\000\255\255\028\000\255\255\255\255\044\000\
    \255\255\081\000\040\000\082\000\043\000\043\000\006\000\006\000\
    \077\000\009\000\006\000\040\000\016\000\043\000\011\000\015\000\
    \010\000\017\000\010\000\069\000\018\000\045\000\044\000\012\000\
    \006\000\047\000\025\000\014\000\052\000\053\000\032\000\044\000\
    \054\000\036\000\078\000\059\000\041\000\024\000\042\000\060\000\
    \061\000\051\000\031\000\057\000\045\000\058\000\074\000\074\000\
    \047\000\079\000\074\000\052\000\053\000\045\000\076\000\054\000\
    \076\000\047\000\059\000\080\000\052\000\053\000\060\000\061\000\
    \054\000\083\000\086\000\059\000\088\000\089\000\040\000\060\000\
    \061\000\093\000\097\000\102\000\102\000\104\000\105\000\102\000\
    \040\000\106\000\107\000\108\000\109\000\110\000\111\000\112\000\
    \114\000\086\000\116\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\097\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\112\000\114\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\006\000\008\000\009\000\010\000\011\000\255\255\255\255\
    \012\000\014\000\015\000\016\000\018\000\066\000\017\000\255\255\
    \255\255\024\000\025\000\255\255\255\255\255\255\019\000\031\000\
    \020\000\021\000\032\000\033\000\036\000\026\000\027\000\037\000\
    \041\000\042\000\255\255\051\000\255\255\255\255\057\000\058\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\028\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\040\000\255\255\043\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\069\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\044\000\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\045\000\255\255\255\255\255\255\
    \047\000\255\255\255\255\052\000\053\000\255\255\255\255\054\000\
    \255\255\255\255\059\000\255\255\255\255\255\255\060\000\061\000\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \097\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    ";
  Lexing.lex_base_code = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\001\000\000\000\004\000\
    \000\000\000\000\000\000\002\000\003\000\000\000\010\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\004\000\005\000\006\000\000\000\007\000\
    \000\000\029\000\021\000\000\000\000\000\008\000\018\000\000\000\
    \035\000\000\000\000\000\000\000\019\000\020\000\000\000\041\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_backtrk_code = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\004\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\010\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\021\000\000\000\
    \029\000\000\000\000\000\000\000\000\000\000\000\000\000\035\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\041\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_default_code = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\001\000\001\000\000\000\000\000\
    \000\000\000\000\000\000\007\000\007\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\013\000\013\000\016\000\000\000\024\000\
    \000\000\000\000\000\000\000\000\000\000\032\000\032\000\000\000\
    \000\000\000\000\000\000\000\000\038\000\038\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_trans_code = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000";
  Lexing.lex_check_code = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\020\000\021\000\027\000\028\000\043\000\044\000\045\000\
    \047\000\053\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\054\000\060\000\061\000\255\255\255\255\
    \020\000\021\000\027\000\028\000\043\000\044\000\045\000\047\000\
    \053\000\020\000\021\000\027\000\028\000\043\000\044\000\045\000\
    \047\000\053\000\054\000\060\000\061\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\054\000\060\000\061\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \020\000\021\000\027\000\028\000\043\000\044\000\045\000\047\000\
    \053\000\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\054\000\060\000\061\000";
  Lexing.lex_code = 
   "\255\001\255\255\000\001\255\002\255\255\000\002\255\003\255\255\
    \004\255\003\255\255\000\003\255\003\255\004\255\255\000\004\255\
    \005\255\255\000\005\255\006\255\255\000\006\255";
}

let rec scanner out dict state lexbuf =
  lexbuf.Lexing.lex_mem <- Array.make 7 (-1) ;   __ocaml_lex_scanner_rec out dict state lexbuf 0
and __ocaml_lex_scanner_rec out dict state lexbuf __ocaml_lex_state =
  match Lexing.new_engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 157 "templater.mll"
   ( output_char out '$'; scanner out dict state lexbuf )
# 448 "templater.ml"

  | 1 ->
let
# 159 "templater.mll"
                            id
# 454 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 10) lexbuf.Lexing.lex_mem.(0)
and
# 159 "templater.mll"
                                              nl
# 459 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_mem.(0) + 1) lexbuf.Lexing.lex_curr_pos in
# 160 "templater.mll"
   (
		let buf = Buffer.contents (scan_end (Buffer.create 1024) 0 lexbuf) in
		let f = do_coll dict id in
		if nl <> "" then incr line;
		f (fun dict -> scanner out dict FOREACH (Lexing.from_string buf)) dict;
		scanner out dict state lexbuf
	)
# 469 "templater.ml"

  | 2 ->
let
# 168 "templater.mll"
                        id
# 475 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 7) lexbuf.Lexing.lex_mem.(0)
and
# 168 "templater.mll"
                                           nl
# 480 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_mem.(0) + 1) lexbuf.Lexing.lex_curr_pos in
# 169 "templater.mll"
 (
		let buf = Buffer.contents (scan_end (Buffer.create 1024) 0 lexbuf) in
		let f = do_coll dict id in
		if nl <> "" then incr line;
		f (fun dict -> scanner out dict WITH (Lexing.from_string buf)) dict;
		scanner out dict state lexbuf
	)
# 490 "templater.ml"

  | 3 ->
let
# 177 "templater.mll"
                     nl
# 496 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 6) lexbuf.Lexing.lex_curr_pos in
# 178 "templater.mll"
 (
		if nl <> "" then incr line;		
		if state = TOP then error "extraneous $(end) tag"
	)
# 503 "templater.ml"

  | 4 ->
let
# 183 "templater.mll"
                      nl
# 509 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 7) lexbuf.Lexing.lex_curr_pos in
# 184 "templater.mll"
 (
		if nl <> "" then incr line;
		if state = THEN then skip out dict 0 lexbuf
		else failwith "'else' out of 'if'"
	)
# 517 "templater.ml"

  | 5 ->
let
# 190 "templater.mll"
                          id
# 523 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 6) lexbuf.Lexing.lex_mem.(0)
and
# 190 "templater.mll"
                                            nl
# 528 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_mem.(0) + 1) lexbuf.Lexing.lex_curr_pos in
# 191 "templater.mll"
 (
		let cond = do_bool dict id in
		if nl <> "" then incr line;
		if not cond then scanner out dict THEN lexbuf
		else skip out dict 0 lexbuf;
		scanner out dict state lexbuf
	)
# 538 "templater.ml"

  | 6 ->
let
# 199 "templater.mll"
                      id
# 544 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 5) lexbuf.Lexing.lex_mem.(0)
and
# 199 "templater.mll"
                                        nl
# 549 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_mem.(0) + 1) lexbuf.Lexing.lex_curr_pos in
# 200 "templater.mll"
 (
		let cond = do_bool dict id in
		if nl <> "" then incr line;
		if cond then scanner out dict THEN lexbuf
		else skip out dict 0 lexbuf;
		scanner out dict state lexbuf
	)
# 559 "templater.ml"

  | 7 ->
let
# 208 "templater.mll"
                         id
# 565 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 8) lexbuf.Lexing.lex_mem.(0)
and
# 208 "templater.mll"
                                           nl
# 570 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_mem.(0) + 1) lexbuf.Lexing.lex_curr_pos in
# 209 "templater.mll"
 (
		let cond = do_ifdef dict id in
		if nl <> "" then incr line;
		if cond then scanner out dict THEN lexbuf
		else skip out dict 0 lexbuf;
		scanner out dict state lexbuf
	)
# 580 "templater.ml"

  | 8 ->
let
# 217 "templater.mll"
                          id
# 586 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 9) lexbuf.Lexing.lex_mem.(0)
and
# 217 "templater.mll"
                                            nl
# 591 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_mem.(0) + 1) lexbuf.Lexing.lex_curr_pos in
# 218 "templater.mll"
 (
		let cond = do_ifdef dict id in
		if nl <> "" then incr line;
		if not cond then scanner out dict THEN lexbuf
		else skip out dict 0 lexbuf;
		scanner out dict state lexbuf
	)
# 601 "templater.ml"

  | 9 ->
let
# 226 "templater.mll"
                    id
# 607 "templater.ml"
= Lexing.sub_lexeme lexbuf (lexbuf.Lexing.lex_start_pos + 2) (lexbuf.Lexing.lex_curr_pos + -1) in
# 227 "templater.mll"
 ( do_text out dict id; scanner out dict state lexbuf )
# 611 "templater.ml"

  | 10 ->
# 230 "templater.mll"
 ( comment out dict state lexbuf )
# 616 "templater.ml"

  | 11 ->
# 233 "templater.mll"
 ( incr line; output_char out '\n'; scanner out dict state lexbuf )
# 621 "templater.ml"

  | 12 ->
let
# 234 "templater.mll"
       c
# 627 "templater.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 235 "templater.mll"
 ( output_char out c; scanner out dict state lexbuf )
# 631 "templater.ml"

  | 13 ->
# 238 "templater.mll"
 ( () )
# 636 "templater.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_scanner_rec out dict state lexbuf __ocaml_lex_state

and comment out dict state lexbuf =
    __ocaml_lex_comment_rec out dict state lexbuf 66
and __ocaml_lex_comment_rec out dict state lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 242 "templater.mll"
  ( incr line; scanner out dict state lexbuf )
# 648 "templater.ml"

  | 1 ->
# 244 "templater.mll"
  ( comment out dict state lexbuf )
# 653 "templater.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_comment_rec out dict state lexbuf __ocaml_lex_state

and skip out dict cnt lexbuf =
    __ocaml_lex_skip_rec out dict cnt lexbuf 69
and __ocaml_lex_skip_rec out dict cnt lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 248 "templater.mll"
   ( skip out dict cnt lexbuf )
# 665 "templater.ml"

  | 1 ->
# 250 "templater.mll"
   ( skip out dict (cnt + 1) lexbuf )
# 670 "templater.ml"

  | 2 ->
# 252 "templater.mll"
 ( skip out dict (cnt + 1) lexbuf )
# 675 "templater.ml"

  | 3 ->
# 254 "templater.mll"
 ( if cnt = 0 then () else skip out dict (cnt -1) lexbuf )
# 680 "templater.ml"

  | 4 ->
# 256 "templater.mll"
 (	if cnt = 0 then scanner out dict ELSE lexbuf
		else skip out dict cnt lexbuf )
# 686 "templater.ml"

  | 5 ->
# 259 "templater.mll"
 ( incr line; skip out dict cnt lexbuf )
# 691 "templater.ml"

  | 6 ->
# 261 "templater.mll"
 ( skip out dict cnt lexbuf )
# 696 "templater.ml"

  | 7 ->
# 263 "templater.mll"
 ( failwith "unclosed if" )
# 701 "templater.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_skip_rec out dict cnt lexbuf __ocaml_lex_state

and scan_end buf cnt lexbuf =
    __ocaml_lex_scan_end_rec buf cnt lexbuf 97
and __ocaml_lex_scan_end_rec buf cnt lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
let
# 267 "templater.mll"
          s
# 714 "templater.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 2) in
# 268 "templater.mll"
   ( Buffer.add_string buf s; scan_end buf cnt lexbuf )
# 718 "templater.ml"

  | 1 ->
let
# 269 "templater.mll"
                       s
# 724 "templater.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 10) in
# 270 "templater.mll"
   ( Buffer.add_string buf s; scan_end buf (cnt + 1) lexbuf )
# 728 "templater.ml"

  | 2 ->
let
# 271 "templater.mll"
                  s
# 734 "templater.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 5) in
# 272 "templater.mll"
 ( Buffer.add_string buf s; scan_end buf (cnt + 1) lexbuf )
# 738 "templater.ml"

  | 3 ->
let
# 273 "templater.mll"
              s
# 744 "templater.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos (lexbuf.Lexing.lex_start_pos + 6) in
# 274 "templater.mll"
 ( if cnt = 0 then buf
	else (Buffer.add_string buf s; scan_end buf (cnt - 1) lexbuf) )
# 749 "templater.ml"

  | 4 ->
# 277 "templater.mll"
 ( incr line; Buffer.add_char buf '\n'; scan_end buf cnt lexbuf )
# 754 "templater.ml"

  | 5 ->
let
# 278 "templater.mll"
       c
# 760 "templater.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 279 "templater.mll"
 ( Buffer.add_char buf c; scan_end buf cnt lexbuf )
# 764 "templater.ml"

  | 6 ->
# 281 "templater.mll"
 ( failwith "unclosed foreach" )
# 769 "templater.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_scan_end_rec buf cnt lexbuf __ocaml_lex_state

;;

# 284 "templater.mll"
 
(** Perform a template generation.
	@param dict		Dictionnary to use.
	@param in_path	Input template path.
	@param out_path	Path of the output file. *)
let generate_path dict in_path out_path =
	let output = open_out out_path in
	let input = open_in in_path in
	file := in_path;
	line := 1;	
	scanner output dict TOP (Lexing.from_channel input);
	close_in input;
	close_out output;
	file := "";
	line := 0

(** Perform a template generation.
	@param dict		Dictionnary to use.
	@param template	Template name (take from SOURCE_DIRECTORY/templates)
	@param out_path	Path of the output file. *)
let generate dict template out_path =
	generate_path dict (Irg.native_path (Config.source_dir ^ "/templates/" ^ template)) out_path

# 800 "templater.ml"
