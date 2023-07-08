### what is this
a runtime determinancy checker for (SWI) prolog

### how to use
(terminology adapted from: https://stackoverflow.com/questions/39804667/has-the-notion-of-semidet-in-prolog-settled )
#### deterministic (det)
if you expect exactly one solution:
`!something(args)`

#### semideterministic (semidet)
if you expect no solutions or one solution:
`?something(args)`

#### multisolution (multi)
if you expect at least one solution but possibly more. Would be:
`+something(args)`.
Seems to be a rare case, not implemented.

#### nondeterministic (nondet)
if you expect zero or more solutions. This is prolog default, nothing to check, but you can express it with:
`*something(args)`

### variations
There are multiple things to choose from here. determinancy_checker_main conditionally includes: 
```
:- if(getenv('DETERMINANCY_CHECKER__USE__ENFORCER', true)).
:- [determinancy_enforcer].
:- else.
:- [determinancy_checker_det_v2].
:- [determinancy_checker_semidet_v1].
:- endif.
```
#### determinancy_enforcer
when memory (and speed) matters. Doesn't tell you if there were multiple solutions where there shouldn't be, only when there was none when there should have been at least one. Implemented like: 
`(call(X)->true;throw(deterministic_call_failed(X))).`

#### determinancy_checker
##### determinancy_checker_det
usage:
`!something(args)`.
Checks that there is exactly one solution. Catches both 0 and >1 results.

Also implemented are cases with more arguments, used with meta-predicates ("A meta-predicate is a predicate that calls other predicates dynamically[..]"). For example maplist gets !something as first argument, and it calls the '!' with a bunch of additional arguments.

You can also include determinancy_checker_det_v1 instead, but v2 is a more abstracted implementation:
###### v2 upsides:
* less code repetition
* when you step inside a '!', it takes one skip to get to the wrapped call
###### v2 downsides:
* throws don't happen right in the '!' predicate, so you cannot just press 'r' in guitracer to try the call again, you have to step out of the helper pred first.
 
##### determinancy_checker_semidet

cases with multiple arguments are todo.


### alternatives: 

#### rdet
See docs/rdet.txt for some tips. Main difference between rdet and determinancy_checker is that with rdet, you declare determinancy of a predicate, while with this, you declare determinancy of a call. I would like to add a "goal_expansion mode" at some point.
##### downsides of rdet
* uses goal expansion, which is imo pretty broken (breaks guitracer)
* requires keeping `:- rdet my_pred/arity.` in sync with your code
##### upsides of rdet
* maybe you have a usecase for declaring determinancy at the level of predicate declarations, rather than for particular invocations. Maybe i'll adapt this into determinancy_checker as optional functionality someday? 

#### this
##### upsides of determinancy_checker:
* declare determinancy at call site, rather than as a property of a predicate.
* no declarations to keep in sync

##### downsides of determinancy_checker:
* swipl doesn't warn you at compile time that a predicate you are calling from somewhere doesn't exist, because !xxx is a call to '!', with xxx just a parameter. This could maybe be alleviated by adding a dummy goal_expansion phase. 
* Having to step through the checker code.

