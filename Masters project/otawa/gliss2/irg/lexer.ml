# 21 "lexer.mll"
 

open Parser
open Lexing
exception BadChar of char
exception BadLine

(* Line count *)
let file = ref ""
let line = ref 1
let line_offset = ref 0
let bitfld = ref false
let lexbuf = ref (Lexing.from_string "")

(* Keyword detection *)
let lexicon = Irg.StringHashtbl.create 211
let keyword id =
	try
		let e=Irg.StringHashtbl.find lexicon id
		in
		match e with
		 EXCEPTION _->EXCEPTION !line
		|LET _->LET !line
		|MEM _->MEM !line
		|MODE _->MODE !line
		|OP _-> OP !line
		|REG _->REG !line
		|VAR _->VAR !line
		|RESOURCE _->RESOURCE !line
		|TYPE _->TYPE !line
		|_->e
	with Not_found -> (ID id)

let keywords = [
	("__attr",		ATTR);
	("action",      ACTION);
	("alias",       ALIAS);
	("ports",       PORTS);
	("bool",        BOOL);
	("canon",		CANON);
	("card",        CARD);
	("case",        CASE);
	("coerce",      COERCE);
	("default",     DEFAULT);
	("do",			DO);
	("else",        ELSE);
	("enddo",		ENDDO);
	("endif",       ENDIF);
	("enum",        ENUM);
	("error",       ERROR);
	("exception",   EXCEPTION 0);
	("extend",		EXTEND);
	("fix",        	FIX);
	("float",       FLOAT);
	("for",			FOR);
	("format",      FORMAT);
	("if",        	IF);
	("image",       IMAGE);
	("in",			IN);
	("initial",     INITIALA);
	("int",        	INT);
	("let",        	LET 0);
	("macro",       MACRO);
	("mem",        	MEM 0);
	("mode",        MODE 0);
	("not",        	NOT);
	("op",        	OP 0);
	("reg",        	REG 0);
	("var",        	VAR 0);
	("resource",    RESOURCE 0);
	("syntax",      SYNTAX);
	("switch",      SWITCH);
	("then",        THEN);
	("type",        TYPE 0);
	("uses",        USES);
	("volatile",    VOLATILE)
]

(* Is the NOP keyword really required ?
	("nop",        	NOP);
*)


let _ =
	let add (key, token) = Irg.StringHashtbl.add lexicon key token in
	Irg.StringHashtbl.clear lexicon;
	List.iter add keywords


(** Compute column of the current symbol.
	@return		Column number. *)
let get_col _ =
	(Lexing.lexeme_start !lexbuf) - !line_offset + 1

(** Output an error on the given stream with the current (file, line, column) position.
	@param out	Output channel.
	@param msg	Message to output. *)
let output_error out msg =
	Printf.fprintf out "ERROR: %s:%d:%d: %s\n" !file !line (get_col ()) msg


(** Output an error with the current (file, line, column) position.
	@param msg	Message to output. *)
let display_error msg = output_error stderr msg


(** Get the current location as a string.
	@return	Current location string. *)
let current_loc _ = Printf.sprintf "%s:%d:%d" !file !line (get_col ())


(** warning management
	@param msg		Message to display. *)
let display_warning msg=
	Printf.fprintf stderr "WARNING: %s:%d:%d: %s\n" !file !line (get_col ()) msg

(* Lexing add-ons *)
let rec dotdot lexbuf i found =
	if i >= lexbuf.lex_buffer_len then
		if lexbuf.lex_eof_reached then false
		else begin
			let diff = i - lexbuf.lex_start_pos in
			lexbuf.refill_buff lexbuf;
			dotdot lexbuf (lexbuf.lex_start_pos + diff) found
		end
	else
		match lexbuf.lex_buffer.[i] with
		  '\n' -> false
		| '.' -> if found then true else dotdot lexbuf (i + 1) true
		| '<' | '>' | '=' | ';' | '}' -> false
		| _ -> dotdot lexbuf (i + 1) false

let gt lexbuf token size =
	if not !bitfld then token
	else begin
		bitfld := false;
		lexbuf.lex_curr_pos <- lexbuf.lex_curr_pos - size;
		GT
	end

let append s c = s ^ (String.make 1 c)

let appends s c =
	let c =
		match c with
		| 'n' -> '\n'
		| 't' -> '\t'
		| 'r' -> '\r'
		| c -> c in
	append s c


(** Record a new line. *)
let new_line lexbuf =
	incr line;
	line_offset := Lexing.lexeme_end lexbuf


# 161 "lexer.ml"
let __ocaml_lex_tables = {
  Lexing.lex_base = 
   "\000\000\204\255\205\255\206\255\207\255\208\255\209\255\212\255\
    \213\255\214\255\215\255\216\255\217\255\218\255\219\255\220\255\
    \221\255\229\255\003\000\025\000\031\000\035\000\086\000\071\000\
    \084\000\071\000\072\000\087\000\164\000\186\000\037\000\250\255\
    \251\255\104\000\254\255\255\255\252\255\253\255\042\000\038\000\
    \048\000\249\255\240\000\174\000\130\000\003\001\026\001\132\000\
    \060\001\087\001\097\001\114\001\124\001\134\001\237\255\088\000\
    \244\255\232\255\123\000\243\255\240\255\239\255\238\255\236\255\
    \235\255\234\255\233\255\001\000\254\255\255\255\234\000\253\255\
    \254\255\164\000\255\255\211\000\253\255\002\000\255\255\254\255\
    \207\000\253\255\003\000\255\255\254\255\187\001\253\255\254\255\
    \172\001\010\001\253\255\254\255\255\255";
  Lexing.lex_backtrk = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\031\000\030\000\033\000\028\000\044\000\032\000\
    \029\000\024\000\025\000\010\000\007\000\007\000\027\000\255\255\
    \255\255\045\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\007\000\008\000\
    \009\000\255\255\009\000\255\255\009\000\255\255\255\255\013\000\
    \255\255\255\255\014\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\002\000\255\255\255\255\255\255\002\000\255\255\255\255\
    \255\255\255\255\002\000\255\255\255\255\255\255\255\255\255\255\
    \000\000\255\255\255\255\255\255\255\255";
  Lexing.lex_default = 
   "\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\000\000\
    \000\000\255\255\000\000\000\000\000\000\000\000\255\255\255\255\
    \255\255\000\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\000\000\255\255\
    \000\000\000\000\255\255\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\068\000\000\000\000\000\071\000\000\000\
    \000\000\255\255\000\000\076\000\000\000\079\000\000\000\000\000\
    \081\000\000\000\084\000\000\000\000\000\086\000\000\000\000\000\
    \255\255\090\000\000\000\000\000\000\000";
  Lexing.lex_trans = 
   "\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\035\000\034\000\069\000\000\000\035\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \035\000\020\000\032\000\030\000\017\000\006\000\019\000\031\000\
    \014\000\013\000\022\000\008\000\015\000\007\000\024\000\033\000\
    \029\000\028\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\023\000\016\000\025\000\021\000\026\000\065\000\
    \003\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\012\000\064\000\011\000\004\000\027\000\
    \063\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\010\000\018\000\009\000\005\000\066\000\
    \062\000\061\000\060\000\058\000\057\000\054\000\055\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\038\000\036\000\039\000\040\000\041\000\056\000\037\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\047\000\047\000\047\000\047\000\027\000\059\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\043\000\074\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\048\000\048\000\
    \043\000\042\000\028\000\028\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\072\000\078\000\083\000\000\000\
    \000\000\000\000\000\000\000\000\044\000\000\000\000\000\042\000\
    \002\000\255\255\255\255\255\255\000\000\000\000\000\000\000\000\
    \000\000\042\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\045\000\092\000\073\000\000\000\000\000\092\000\
    \000\000\000\000\000\000\053\000\044\000\053\000\000\000\042\000\
    \052\000\052\000\052\000\052\000\052\000\052\000\052\000\052\000\
    \052\000\052\000\092\000\082\000\091\000\000\000\000\000\077\000\
    \000\000\000\000\045\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\000\000\000\000\000\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\000\000\000\000\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\000\000\000\000\
    \000\000\000\000\000\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\049\000\051\000\000\000\051\000\000\000\000\000\050\000\
    \050\000\050\000\050\000\050\000\050\000\050\000\050\000\050\000\
    \050\000\050\000\050\000\050\000\050\000\050\000\050\000\050\000\
    \050\000\050\000\050\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\049\000\050\000\050\000\050\000\050\000\050\000\050\000\
    \050\000\050\000\050\000\050\000\052\000\052\000\052\000\052\000\
    \052\000\052\000\052\000\052\000\052\000\052\000\052\000\052\000\
    \052\000\052\000\052\000\052\000\052\000\052\000\052\000\052\000\
    \000\000\000\000\000\000\000\000\087\000\000\000\000\000\000\000\
    \087\000\000\000\000\000\000\000\000\000\000\000\000\000\255\255\
    \000\000\000\000\000\000\255\255\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\087\000\088\000\088\000\088\000\088\000\
    \088\000\088\000\088\000\088\000\088\000\088\000\000\000\000\000\
    \000\000\000\000\255\255\088\000\088\000\088\000\088\000\088\000\
    \088\000\088\000\088\000\088\000\088\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\255\255\000\000\000\000\000\000\000\000\000\000\
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
    \000\000\000\000\000\000\255\255";
  Lexing.lex_check = 
   "\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\000\000\000\000\067\000\255\255\000\000\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\019\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\
    \021\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
    \000\000\000\000\000\000\000\000\000\000\000\000\000\000\018\000\
    \022\000\023\000\024\000\025\000\025\000\026\000\026\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\030\000\033\000\038\000\039\000\040\000\055\000\033\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\044\000\044\000\047\000\047\000\027\000\058\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\027\000\027\000\027\000\027\000\027\000\027\000\
    \027\000\027\000\028\000\073\000\028\000\028\000\028\000\028\000\
    \028\000\028\000\028\000\028\000\028\000\028\000\043\000\043\000\
    \043\000\043\000\043\000\043\000\043\000\043\000\043\000\043\000\
    \029\000\028\000\029\000\029\000\029\000\029\000\029\000\029\000\
    \029\000\029\000\029\000\029\000\070\000\075\000\080\000\255\255\
    \255\255\255\255\255\255\255\255\029\000\255\255\255\255\029\000\
    \000\000\067\000\077\000\082\000\255\255\255\255\255\255\255\255\
    \255\255\028\000\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\029\000\089\000\070\000\255\255\255\255\089\000\
    \255\255\255\255\255\255\042\000\029\000\042\000\255\255\029\000\
    \042\000\042\000\042\000\042\000\042\000\042\000\042\000\042\000\
    \042\000\042\000\089\000\080\000\089\000\255\255\255\255\075\000\
    \255\255\255\255\029\000\045\000\045\000\045\000\045\000\045\000\
    \045\000\045\000\045\000\045\000\045\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\045\000\045\000\045\000\045\000\
    \045\000\045\000\046\000\046\000\046\000\046\000\046\000\046\000\
    \046\000\046\000\046\000\046\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\046\000\046\000\046\000\046\000\046\000\
    \046\000\255\255\255\255\255\255\045\000\045\000\045\000\045\000\
    \045\000\045\000\255\255\255\255\048\000\048\000\048\000\048\000\
    \048\000\048\000\048\000\048\000\048\000\048\000\255\255\255\255\
    \255\255\255\255\255\255\046\000\046\000\046\000\046\000\046\000\
    \046\000\048\000\049\000\255\255\049\000\255\255\255\255\049\000\
    \049\000\049\000\049\000\049\000\049\000\049\000\049\000\049\000\
    \049\000\050\000\050\000\050\000\050\000\050\000\050\000\050\000\
    \050\000\050\000\050\000\255\255\255\255\255\255\255\255\255\255\
    \255\255\048\000\051\000\051\000\051\000\051\000\051\000\051\000\
    \051\000\051\000\051\000\051\000\052\000\052\000\052\000\052\000\
    \052\000\052\000\052\000\052\000\052\000\052\000\053\000\053\000\
    \053\000\053\000\053\000\053\000\053\000\053\000\053\000\053\000\
    \255\255\255\255\255\255\255\255\085\000\255\255\255\255\255\255\
    \085\000\255\255\255\255\255\255\255\255\255\255\255\255\080\000\
    \255\255\255\255\255\255\075\000\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\085\000\088\000\088\000\088\000\088\000\
    \088\000\088\000\088\000\088\000\088\000\088\000\255\255\255\255\
    \255\255\255\255\070\000\085\000\085\000\085\000\085\000\085\000\
    \085\000\085\000\085\000\085\000\085\000\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
    \255\255\255\255\089\000\255\255\255\255\255\255\255\255\255\255\
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
    \255\255\255\255\255\255\085\000";
  Lexing.lex_base_code = 
   "";
  Lexing.lex_backtrk_code = 
   "";
  Lexing.lex_default_code = 
   "";
  Lexing.lex_trans_code = 
   "";
  Lexing.lex_check_code = 
   "";
  Lexing.lex_code = 
   "";
}

let rec main lexbuf =
    __ocaml_lex_main_rec lexbuf 0
and __ocaml_lex_main_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 202 "lexer.mll"
        ( main lexbuf )
# 401 "lexer.ml"

  | 1 ->
# 203 "lexer.mll"
           ( new_line lexbuf; main lexbuf )
# 406 "lexer.ml"

  | 2 ->
# 204 "lexer.mll"
        ( eof_comment lexbuf )
# 411 "lexer.ml"

  | 3 ->
# 205 "lexer.mll"
        ( comment lexbuf )
# 416 "lexer.ml"

  | 4 ->
# 207 "lexer.mll"
        ( STRING_CONST  (str "" lexbuf) )
# 421 "lexer.ml"

  | 5 ->
# 208 "lexer.mll"
        ( chr "" lexbuf )
# 426 "lexer.ml"

  | 6 ->
# 209 "lexer.mll"
           ( scan_line lexbuf; scan_file lexbuf; main lexbuf )
# 431 "lexer.ml"

  | 7 ->
let
# 211 "lexer.mll"
        v
# 437 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 211 "lexer.mll"
            (	try CARD_CONST (Int32.of_string v)
					with Failure _-> CARD_CONST_64 (Int64.of_string v) )
# 442 "lexer.ml"

  | 8 ->
let
# 214 "lexer.mll"
            v
# 448 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 214 "lexer.mll"
               (	let size = (String.length v) - 2 in
				try(
					BIN_CONST (Int32.of_string v, size)
				)with Failure _-> BIN_CONST_64 (Int64.of_string v, size)
			)
# 456 "lexer.ml"

  | 9 ->
let
# 222 "lexer.mll"
         v
# 462 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 222 "lexer.mll"
           ( FIXED_CONST (float_of_string v) )
# 466 "lexer.ml"

  | 10 ->
let
# 223 "lexer.mll"
        v
# 472 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 223 "lexer.mll"
           (  keyword v )
# 476 "lexer.ml"

  | 11 ->
# 224 "lexer.mll"
         ( gt lexbuf ROTATE_RIGHT 2 )
# 481 "lexer.ml"

  | 12 ->
# 225 "lexer.mll"
         ( ROTATE_LEFT )
# 486 "lexer.ml"

  | 13 ->
# 226 "lexer.mll"
        ( gt lexbuf RIGHT_SHIFT 1 )
# 491 "lexer.ml"

  | 14 ->
# 227 "lexer.mll"
        ( LEFT_SHIFT )
# 496 "lexer.ml"

  | 15 ->
# 228 "lexer.mll"
        ( DOUBLE_DOT )
# 501 "lexer.ml"

  | 16 ->
# 229 "lexer.mll"
        ( DOUBLE_COLON )
# 506 "lexer.ml"

  | 17 ->
# 230 "lexer.mll"
        ( DOUBLE_STAR )
# 511 "lexer.ml"

  | 18 ->
# 231 "lexer.mll"
        ( gt lexbuf GEQ 1 )
# 516 "lexer.ml"

  | 19 ->
# 232 "lexer.mll"
        ( EQU )
# 521 "lexer.ml"

  | 20 ->
# 233 "lexer.mll"
        ( NEQ )
# 526 "lexer.ml"

  | 21 ->
# 234 "lexer.mll"
        ( AND )
# 531 "lexer.ml"

  | 22 ->
# 235 "lexer.mll"
        ( OR )
# 536 "lexer.ml"

  | 23 ->
# 236 "lexer.mll"
        ( LEQ )
# 541 "lexer.ml"

  | 24 ->
# 237 "lexer.mll"
       (
			 if dotdot lexbuf lexbuf.lex_last_pos false
				then
					begin bitfld := true; BIT_LEFT end
				else
					LT
			)
# 552 "lexer.ml"

  | 25 ->
# 244 "lexer.mll"
           ( bitfld := false; GT )
# 557 "lexer.ml"

  | 26 ->
# 245 "lexer.mll"
           ( DOLLAR )
# 562 "lexer.ml"

  | 27 ->
# 246 "lexer.mll"
       ( SHARP )
# 567 "lexer.ml"

  | 28 ->
# 247 "lexer.mll"
       ( EQ )
# 572 "lexer.ml"

  | 29 ->
# 248 "lexer.mll"
       ( DOT )
# 577 "lexer.ml"

  | 30 ->
# 249 "lexer.mll"
       ( AMPERS )
# 582 "lexer.ml"

  | 31 ->
# 250 "lexer.mll"
       ( PIPE )
# 587 "lexer.ml"

  | 32 ->
# 251 "lexer.mll"
       ( COLON )
# 592 "lexer.ml"

  | 33 ->
# 252 "lexer.mll"
       ( EXCLAM )
# 597 "lexer.ml"

  | 34 ->
# 253 "lexer.mll"
       ( SEMI )
# 602 "lexer.ml"

  | 35 ->
# 254 "lexer.mll"
       ( COMMA )
# 607 "lexer.ml"

  | 36 ->
# 255 "lexer.mll"
       ( LPAREN )
# 612 "lexer.ml"

  | 37 ->
# 256 "lexer.mll"
       ( RPAREN )
# 617 "lexer.ml"

  | 38 ->
# 257 "lexer.mll"
       ( LBRACK )
# 622 "lexer.ml"

  | 39 ->
# 258 "lexer.mll"
       ( RBRACK )
# 627 "lexer.ml"

  | 40 ->
# 259 "lexer.mll"
       ( LBRACE )
# 632 "lexer.ml"

  | 41 ->
# 260 "lexer.mll"
       ( RBRACE )
# 637 "lexer.ml"

  | 42 ->
# 261 "lexer.mll"
       ( PLUS )
# 642 "lexer.ml"

  | 43 ->
# 262 "lexer.mll"
       ( MINUS )
# 647 "lexer.ml"

  | 44 ->
# 263 "lexer.mll"
       ( STAR )
# 652 "lexer.ml"

  | 45 ->
# 264 "lexer.mll"
       ( SLASH )
# 657 "lexer.ml"

  | 46 ->
# 265 "lexer.mll"
       ( PERCENT )
# 662 "lexer.ml"

  | 47 ->
# 266 "lexer.mll"
       ( TILD )
# 667 "lexer.ml"

  | 48 ->
# 267 "lexer.mll"
       ( CIRC )
# 672 "lexer.ml"

  | 49 ->
# 268 "lexer.mll"
       ( AROBAS )
# 677 "lexer.ml"

  | 50 ->
# 270 "lexer.mll"
       ( EOF )
# 682 "lexer.ml"

  | 51 ->
let
# 271 "lexer.mll"
       v
# 688 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 271 "lexer.mll"
          ( raise (BadChar v) )
# 692 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_main_rec lexbuf __ocaml_lex_state

and eof_comment lexbuf =
    __ocaml_lex_eof_comment_rec lexbuf 67
and __ocaml_lex_eof_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 275 "lexer.mll"
      ( new_line lexbuf; main lexbuf )
# 704 "lexer.ml"

  | 1 ->
# 276 "lexer.mll"
     ( eof_comment lexbuf )
# 709 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_eof_comment_rec lexbuf __ocaml_lex_state

and comment lexbuf =
    __ocaml_lex_comment_rec lexbuf 70
and __ocaml_lex_comment_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 280 "lexer.mll"
      ( main lexbuf )
# 721 "lexer.ml"

  | 1 ->
# 282 "lexer.mll"
       ( new_line lexbuf; comment lexbuf )
# 726 "lexer.ml"

  | 2 ->
# 283 "lexer.mll"
     ( comment lexbuf )
# 731 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_comment_rec lexbuf __ocaml_lex_state

and str res lexbuf =
    __ocaml_lex_str_rec res lexbuf 75
and __ocaml_lex_str_rec res lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 287 "lexer.mll"
        ( res )
# 743 "lexer.ml"

  | 1 ->
let
# 288 "lexer.mll"
             v
# 749 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf (lexbuf.Lexing.lex_start_pos + 1) in
# 288 "lexer.mll"
                ( str (appends res v) lexbuf )
# 753 "lexer.ml"

  | 2 ->
let
# 289 "lexer.mll"
       v
# 759 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 289 "lexer.mll"
           ( str (append res v) lexbuf )
# 763 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_str_rec res lexbuf __ocaml_lex_state

and chr res lexbuf =
    __ocaml_lex_chr_rec res lexbuf 80
and __ocaml_lex_chr_rec res lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 293 "lexer.mll"
        ( STRING_CONST res )
# 775 "lexer.ml"

  | 1 ->
let
# 294 "lexer.mll"
             v
# 781 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf (lexbuf.Lexing.lex_start_pos + 1) in
# 294 "lexer.mll"
                ( chr (appends res v) lexbuf )
# 785 "lexer.ml"

  | 2 ->
let
# 295 "lexer.mll"
       v
# 791 "lexer.ml"
= Lexing.sub_lexeme_char lexbuf lexbuf.Lexing.lex_start_pos in
# 295 "lexer.mll"
           ( chr (append res v) lexbuf )
# 795 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_chr_rec res lexbuf __ocaml_lex_state

and scan_line lexbuf =
    __ocaml_lex_scan_line_rec lexbuf 85
and __ocaml_lex_scan_line_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
let
# 298 "lexer.mll"
           l
# 808 "lexer.ml"
= Lexing.sub_lexeme lexbuf lexbuf.Lexing.lex_start_pos lexbuf.Lexing.lex_curr_pos in
# 298 "lexer.mll"
             ( line := (int_of_string l) - 1 )
# 812 "lexer.ml"

  | 1 ->
# 299 "lexer.mll"
         ( scan_line lexbuf )
# 817 "lexer.ml"

  | 2 ->
# 300 "lexer.mll"
      ( raise BadLine )
# 822 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_scan_line_rec lexbuf __ocaml_lex_state

and scan_file lexbuf =
    __ocaml_lex_scan_file_rec lexbuf 89
and __ocaml_lex_scan_file_rec lexbuf __ocaml_lex_state =
  match Lexing.engine __ocaml_lex_tables __ocaml_lex_state lexbuf with
      | 0 ->
# 303 "lexer.mll"
        ( scan_file lexbuf )
# 834 "lexer.ml"

  | 1 ->
# 304 "lexer.mll"
        ( file := (str "" lexbuf) )
# 839 "lexer.ml"

  | 2 ->
# 305 "lexer.mll"
      ( raise BadLine )
# 844 "lexer.ml"

  | __ocaml_lex_state -> lexbuf.Lexing.refill_buff lexbuf; 
      __ocaml_lex_scan_file_rec lexbuf __ocaml_lex_state

;;
