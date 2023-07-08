'!'(X) :-
	det_with(Call_id, X),
	call(X),
	det_nbinc(Call_id, X).

'!'(X, Y) :-
	det_with(Call_id, (X, Y)),
	call(X, Y),
	det_nbinc(Call_id, (X, Y)).

'!'(X, Y, Z) :-
	det_with(Call_id, (X, Y, Z)),
	call(X, Y, Z),
	det_nbinc(Call_id, (X, Y, Z)).

'!'(X, Y, Z, ZZ) :-
	det_with(Call_id, (X, Y, Z, ZZ)),
	call(X, Y, Z, ZZ),
	det_nbinc(Call_id, (X, Y, Z, ZZ)).

det_with(Call_id, Call) :-
%
	%gensym(determinancy_checker__deterministic_call__progress, Call_id),
%
	flag(determinancy_checker__deterministic_call__progress, Call_id_num, Call_id_num+1),
    atom_concat(dtc, Call_id_num, Call_id),
%
	(
		nb_setval(Call_id, 0)
	;
		(
			nb_getval(Call_id, 1)
		->
			(
				nb_delete(Call_id),
				fail
			)
		;
			determinancy_checker_throw_error(error(deterministic_call_failed(Call),_))
		)
	).

det_nbinc(Call_id, Call) :-
	nb_getval(Call_id, Sols),
	(	Sols = 0
	->	nb_setval(Call_id, 1)
	;	determinancy_checker_throw_error((deterministic_call_found_a_second_solution(Call)))).


