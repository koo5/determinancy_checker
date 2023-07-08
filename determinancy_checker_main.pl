:- module(_, [
	op(812,fx,!),
	op(812,fx,?),
	op(812,fx,*),

	/* is nondet. This is just a no-op annotation */
	'*'/1,

	/* must have one solution */
	'!'/1,
	'!'/2,
	'!'/3,
	'!'/4,

	/* must have zero or one solution */
	'?'/1

	/* must have one or more solutions(to be done) */
	/*'+'/1*/
]).

:- use_module('../../prolog/utils/envvars', [env_bool/2]).



:- meta_predicate '*'(0).
:- meta_predicate '*'(1, ?).
:- meta_predicate '*'(2, ?, ?).
:- meta_predicate '*'(3, ?, ?, ?).
:- meta_predicate '*'(4, ?, ?, ?, ?).
/* todo make this a macro? */
'*'(Callable) :-
	call(Callable).
'*'(Callable,A1) :-
	call(Callable,A1).
'*'(Callable,A1,A2) :-
	call(Callable,A1,A2).
'*'(Callable,A1,A2,A3) :-
	call(Callable,A1,A2,A3).
'*'(Callable,A1,A2,A3,A4) :-
	call(Callable,A1,A2,A3,A4).


:- meta_predicate '!'(0).
:- meta_predicate '!'(1, ?).
:- meta_predicate '!'(2, ?, ?).
:- meta_predicate '!'(3, ?, ?, ?).


:- multifile determinancy_checker_throw_error/1.
%:- dynamic determinancy_checker_throw_error/1.

 determinancy_checker_throw_error(E) :-
	gtrace,throw(E).

env_bool_has_default('DETERMINANCY_CHECKER__USE__ENFORCER', false).
env_bool_has_default('DETERMINANCY_CHECKER__USE__UNDO', false).

:- if(env_bool('DETERMINANCY_CHECKER__USE__ENFORCER', true)).
	:- debug(determinancy_checker, "'DETERMINANCY_CHECKER__USE__ENFORCER', true",[]).
	:- [determinancy_enforcer].
:- else.
	:- if(env_bool('DETERMINANCY_CHECKER__USE__UNDO', true)).
		:- [determinancy_checker_det_v3_undo].
	:- else.
		:- [determinancy_checker_det_v2].
	:- endif.

	:- [determinancy_checker_semidet_v1].
:- endif.



prolog:message(deterministic_call_found_a_second_solution(X)) --> [deterministic_call_found_a_second_solution(X)].
%prolog:message(deterministic_call_failed(X)) --> [deterministic_call_failed(X)].
prolog:message(E) --> {E = error(determinancy_checker(X),_), term_string(X, Str)}, [Str].



/*
todo:
:- maplist(!member, [1], _).

	% wrt the possibility of getting multiple results for the above query, this would be a good place to introduce something like scopes or configurations into determinancy checker. That is, '!' would mean the default/only scope, you control what exactly it does by prolog flags, but you could also have, let's say, !(db), that would have a separate debug level. Ie, i may want to trust my code to run in release mode, but still don't trust the db data - don't want to check that my code doesn't produce multiple results, but want to check that the database doesn't contain multiple records.

*/

/*

todo harmonize with this a bit?
https://github.com/mthom/scryer-prolog/blob/master/src/lib/debug.pl

*/
