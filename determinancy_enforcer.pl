/*
a "performant" implmentation/stub, it cuts after first solution and doesn't check if there were more.
*/


'!'(X) :-
	(call(X)->true;determinancy_checker_throw_error(deterministic_call_failed(X))).

'!'(X,A1) :-
	(call(X,A1)->true;determinancy_checker_throw_error(deterministic_call_failed((X,A1)))).

'!'(X,A1,A2) :-
	(call(X,A1,A2)->true;determinancy_checker_throw_error(deterministic_call_failed((X,A1,A2)))).

'!'(X,A1,A2,A3) :-
	(call(X,A1,A2,A3)->true;determinancy_checker_throw_error(deterministic_call_failed((X,A1,A2,A3)))).

'?'(X) :-
	call(X),!.

