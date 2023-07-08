'?'(X) :-
	gensym(determinancy_checker__semideterministic_call__progress, Call_id),
	determinancy_checker_semidet_with(Call_id),
	call(X),
	determinancy_checker_semidet_nbinc(Call_id, X).

determinancy_checker_semidet_with(Call_id) :-
	nb_setval(Call_id, 0)
	;(nb_delete(Call_id),fail).

determinancy_checker_semidet_nbinc(Call_id, X) :-
	catch(
		nb_getval(Call_id, _),
		_,
		determinancy_checker_throw_error(semideterministic_call_has_multiple_solutions(X))
	),
	nb_delete(Call_id).

