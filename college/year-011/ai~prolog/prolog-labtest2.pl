% check father and mother

parent(dave, charlie).
parent(dave, jack).
parent(laura, charlie).
parent(laura, jack).
male(dave).
male(charlie).
male(jack).
male(mark).
male(daddy).
female(mommy).

female(laura).

% grand parents
parent(mark, ketty).

father(daddy, dave).
father(daddy, mark).
mother(mommy, dave).
mother(mommy, mark).

% father
father(A,B) :- male(A) , parent(A,B).

% mother
mother(A,B) :- female(A) , parent(A,B).

% grand mother
grandMother(Grandmother, Child) :- mother(Grandmother, X), mother(X, Child); father(X, Child).

% grand father
grandFather(Grandfather, Child) :- father(Grandfather, X), father(X, Child); mother(X, Child).

% first cousins
cousins(One, Two) :- grandFather(G, One) , grandFather(G, Two) ;
					grandMother(G, One) , grandMother(G, Two).

% check if cousins
% cousins(charlie, ketty).
% check if grandfathers
% grandFather(daddy, charlie).
% check if grandMother
% grandMother(mommy, ketty).


% Q2.
byCar(auckland,hamilton).
byCar(hamilton,raglan).
byCar(valmont,saarbruecken).
byCar(valmont,metz).
byTrain(metz,frankfurt).
byTrain(saarbruecken,frankfurt).
byTrain(metz,paris).
byTrain(saarbruecken,paris).
byPlane(frankfurt,bangkok).
byPlane(frankfurt,singapore).
byPlane(paris,losAngeles).
byPlane(bangkok,auckland).
byPlane(singapore,auckland).
byPlane(losAngeles,auckland).

% direct routes are base case
goDirect(A, B) :-
	byCar(A, B);
	byTrain(A,B);
	byPlane(A,B).

% the base case
canGoFrom(A,B) :-
	goDirect(A,B).

% go via another routes: go from closer city then continue from there
canGoFrom(A,B) :-
	goDirect(A, C) , canGoFrom(C, B).

% test
% ?- canGoFrom(valmont,raglan).
% true .



% Q3. give the route used to travel
travel(A, B, [A,B]) :- goDirect(A,B).
travel(A,B, [A, Path]) :- goDirect(A,C), travel(C,B, Path).

travelPath(A,B):-
	travel(A, B, Path),
	write('the path is: '), write(Path).
% travelPath test

% ?- travelPath(valmont,raglan).
% the path is: [valmont,[saarbruecken,[frankfurt,[bangkok,[auckland,
% [hamilton,raglan]]]]]]
% true
% the path is: [valmont,[saarbruecken,[frankfurt,[singapore,[auckland,[hamilton,raglan]]]]]]
% true
% the path is: [valmont,[saarbruecken,[paris,[losAngeles,[auckland,[hamilton,raglan]]]]]]
% true
% the path is: [valmont,[metz,[frankfurt,[bangkok,[auckland,[hamilton,raglan]]]]]]
% true
% the path is: [valmont,[metz,[frankfurt,[singapore,[auckland,[hamilton,raglan]]]]]]
% true
% the path is: [valmont,[metz,[paris,[losAngeles,[auckland,[hamilton,raglan]]]]]]
% true
% false.

% ?-


% Q4. Modify travel/3 from last question so that circular routes are not possible.





% Q5: Write list predicates to:
% dupList(L1, L) where dupList([1,3,a,0],L) gives L = [1,1,3,3,a,a,0,0]

% base case
dupList([], []).

dupList([H|T], L) :-
	D is [H,H],
	L is [D|L],
	dupList(T, L).

% remEvery2nd(L1, L) where remEvery2nd([1,2,dd,e,6,7] L) give L = [1,dd,6]
remEvery2nd([], []).
remEvery2nd([H,M,Tail], [H,Tail]).

% mulLists(L1, L2, L) where mulLists( [(1,3,5], [8,7, 2], L) gives L = [8, 21, 10]
mulLists([],0).
mulLists([H],H).
mulLists([H|T], Product) :- mulLists(T, Rest), Product is H * Rest.

% countAtoms(L, N) where countAtoms([1, a, f(a,b), age(4), ba], N) gives N = 2



% mkList(X, N, L) where mkList(a, 5, L) gives L = [a, a, a, a, a]. It replicates the value of X N times to form
