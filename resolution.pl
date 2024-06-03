/*
    1. YES
    2. YES
    3. YES
    4. NO
    5. YES
    6. YES 
    7. YES
    8. NO
    9. NO
    10. YES
*/
 
?-op(140, fy, neg).
?-op(160, xfy, [and, or, imp, revimp, uparrow, downarrow, notimp, notrevimp, equiv, notequiv]).


opposite(X, neg X).
opposite(neg X, X).


conjunctive(_ and _).
conjunctive(_ downarrow _).
conjunctive(_ notimp _).
conjunctive(_ notrevimp _).
conjunctive(neg(_ or _)).
conjunctive(neg(_ imp _)).
conjunctive(neg(_ revimp _)).
conjunctive(neg(_ uparrow _)).


disjunctive(_ or _).
disjunctive(_ imp _).
disjunctive(neg(_ downarrow _)).
disjunctive(neg(_ notimp _)).
disjunctive(neg(_ notrevimp _)).
disjunctive(neg(_ and _)).
disjunctive(_ revimp _).
disjunctive(_ uparrow _).

unary(neg neg _).
unary(neg true).
unary(neg false).



equivalent(_ equiv _).
equivalent(_ notequiv _).
equivalent(neg(_ equiv _)).
equivalent(neg(_ notequiv _)).



components(X and Y, X, Y).
components(X imp Y, neg X, Y).
components(X or Y, X, Y).
components(X revimp Y, X, neg Y).
components(X uparrow Y, neg X, neg Y).
components(X downarrow Y, neg X, neg Y).
components(X notimp Y, X, neg Y).
components(neg(X imp Y), X, neg Y).
components(neg(X and Y), neg X, neg Y).
components(neg(X or Y), neg X, neg Y).
components(neg(X revimp Y), neg X, Y).
components(neg(X uparrow Y), X, Y).
components(neg(X downarrow Y), X, Y).
components(neg(X notimp Y), neg X, Y).
components(X notrevimp Y, neg X, Y).
components(neg(X notrevimp Y), X, neg Y).



component(neg(X equiv Y), (neg X or neg Y) and (X or Y)).
component(X notequiv Y, (neg X or neg Y) and (X or Y)).
component(X equiv Y, (neg X or Y) and (X or neg Y)).
component(neg(X notequiv Y), (neg X or Y) and (X or neg Y)).
component(neg neg X, X).
component(neg false, true).
component(neg true, false).


expand(Formula, Return) :-
    singlestep(Formula, Temp),!
    ,expand(Temp, Return).
expand(Formula, Return) :-
    removedups(Formula,NewConj),
    removeOpps(NewConj,NewNewConj),     
    resolution(NewNewConj, Return).  


singlestep([Disj | Rest], New) :- 
    select(Formula, Disj, Temp),
	unary(Formula),
    component(Formula, NewFormula),
	New = [[NewFormula | Temp] | Rest]. 


singlestep([Disjunction|Rest], New) :-
    select(Formula,Disjunction,Temp),
    equivalent(Formula),
    component(Formula, Newformula),
    New = [[Newformula | Temp] | Rest].


singlestep([Disjunction|Rest], New) :-
    select(Alpha, Disjunction, Temp),
	conjunctive(Alpha), 
    components(Alpha, Alphadisone, Alphadistwo),
	New = [[Alphadisone | Temp], [Alphadistwo | Temp] | Rest].

singlestep([Disjunction | Rest], New) :- 
    select(Beta, Disjunction, Temp),
	disjunctive(Beta), 
    components(Beta, Betaone, Betatwo),
	New = [[Betaone, Betatwo | Temp] | Rest].


singlestep([Disjunction | Rest], Rest) :-          
    member(true, Disjunction).


singlestep([Disjunction | Rest], [Temp | Rest]) :-      
    select(false, Disjunction, Temp).


singlestep([Disj | Rest], [Disj | NewRest]) :-
    singlestep(Rest, NewRest).


resolution(Formula, Return) :-
    resolutionstep(Formula, Temp), 
    resolution(Temp, Return).
resolution(Formula, Formula) :-
    member([], Formula).

resolutionstep([Dis1|Rest], [ Dis1 | Newrest ]) :-  
    resolutionstep(Rest, Newrest).


resolutionstep([Disj1|Rest], New) :-
    select(Literal, Disj1, NewDisj1),
    member(Disj2,Rest),
    not(Disj1=Disj2),
	select(neg Literal, Disj2, NewDisj2),
	ord_union(NewDisj1, NewDisj2, NewDisj),
    select(Disj2, Rest, Newrest), 
    not(oppositeExists(NewDisj)),
    New=[NewDisj| Newrest].   


resolutionstep([Disj1|Rest], New) :-
    select(neg Literal, Disj1, NewDisj1),
    member(Disj2,Rest),
    not(Disj1=Disj2),
	select( Literal, Disj2, NewDisj2),
	ord_union(NewDisj1, NewDisj2, NewDisj),
    select(Disj2, Rest, Newrest), 
    not(oppositeExists(NewDisj)),
    New=[NewDisj| Newrest].  


oppositeExists([]):-false.      
oppositeExists(Disj) :- member(X, Disj), opposite(X, Opp), member(Opp, Disj).


removeOpps([],[]).
removeOpps([Disj | Rest],  [Disj | Result]) :- 
    not(oppositeExists(Disj)),
    removeOpps(Rest,Result).        
removeOpps([Disj | Rest], Result) :- 
    oppositeExists(Disj),
    removeOpps(Rest,Result).


removedups([], []).
removedups([Disj | Rest], [OrdDisj | NewRest]) :- 
    list_to_ord_set(Disj, OrdDisj),
	removedups(Rest, NewRest).


test(Formula) :-
    expand([[neg Formula]], Y)-> print("YES"); print("NO").
