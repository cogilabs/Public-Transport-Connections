/* This program simulates routes in a simplified version of the Linz tram network */
% Here we define the tram stops

				stop(universitat, [l01,l02]).
				stop(wildbergstrasse, [l01,l02]).
				stop(rudolfstrasse, [l01,l02,l03,l04,l50]).
				stop(hauptplatz, [l01,l02,l03,l04,l50]).
				stop(burgerstrasse, [l01,l02,l03,l04]).
				stop(hauptbahnhof, [l01,l02,l03,l04]).
				stop(scharlinz, [l01,l02]).
				stop(simonystrasse, [l01,l02]).
				stop(durerstrasse, [l01]).
				stop(auwiesen, [l01]).
				stop(ebelsberg, [l02]).
				stop(ennfeld, [l02]).
				stop(bahnhofEbelsberg, [l02]).
				stop(solarCity, [l02]).
				stop(landgutstrasse, [l03,l04,l50]).
				stop(muhlkreisbahnhof, [l03,l04,l50]).
				stop(untergaumberg, [l03,l04]).
				stop(haag, [l03,l04]).
				stop(plusCity, [l03,l04]).
				stop(traunerKreuzung, [l03,l04]).
				stop(traunerKreuzungPR, [l03]).
				stop(schlossTraun, [l04]).
				stop(bruckneruniversitat, [l50]).
				stop(postlingberg, [l50]).

/*===================*/

% Here we check have the rules to check if two stops are adjacent to eachother
	% This first rule allows the programm to check both ways in a single command
		adjacent(X,Y):- adjacent_stops(X,Y).
		adjacent(X,Y):- adjacent_stops(Y,X).

		%l01
			adjacent_stops(universitat,wildbergstrasse).
			adjacent_stops(wildbergstrasse,rudolfstrasse).
			adjacent_stops(rudolfstrasse,hauptplatz).
			adjacent_stops(hauptplatz,burgerstrasse).
			adjacent_stops(burgerstrasse,hauptbahnhof).
			adjacent_stops(hauptbahnhof,scharlinz).
			adjacent_stops(scharlinz,simonystrasse).
			adjacent_stops(simonystrasse,durerstrasse).
			adjacent_stops(durerstrasse,auwiesen).
		%l02
			adjacent_stops(simonystrasse,ebelsberg).
			adjacent_stops(ebelsberg,ennfeld).
			adjacent_stops(ennfeld,bahnhofEbelsberg).
			adjacent_stops(bahnhofEbelsberg,solarCity).
		%l03
			adjacent_stops(landgutstrasse,muhlkreisbahnhof).
			adjacent_stops(muhlkreisbahnhof,rudolfstrasse).
			adjacent_stops(hauptbahnhof,untergaumberg).
			adjacent_stops(untergaumberg,haag).
			adjacent_stops(haag,plusCity).
			adjacent_stops(plusCity,traunerKreuzung).
			adjacent_stops(traunerKreuzung,traunerKreuzungPR).
		%l04
			adjacent_stops(traunerKreuzung,schlossTraun).
		%l50
			adjacent_stops(postlingberg,bruckneruniversitat).
			adjacent_stops(bruckneruniversitat,landgutstrasse).

/*===================*/

% Here we check if two stops are on the same line
	% Sameline
		sameline(Stop1, Stop2, Line):-
			stop(Stop1, Line1), 			/*Declares Stop1 as the Atom of stop. For Example: Stop1 = stop(auwiesen, [l01]). */
			stop(Stop2, Line2),			/*Declares Stop2 as an atom of stop.*/
			member(Line, Line1),      			/*Checks if Line is a member of Line1.*/
			member(Line, Line2).	  			/*Checks if Line is a member of Line2.*/

	% This rule is really to understand, if Line1 and Line2 are both members of Line,
	% it means both stops are on the same line

/*===================*/

% Find all stops on a line
		findAllStops(Line, ListOfStops):-
			findall(Stop,(stop(Stop,NewLine), member(Line, NewLine)), ListOfStops).

	% This rule returns every stops on the inputed line.
	%	Essentially, it calls a findall function which goes trough the initial stops list,
	%	and checks for every of them if it is on the inputed line.

/*===================*/

% Check how many trains pass through a stop
		numberOfLines(Stop, NumberOfLines) :-
			stop(Stop,Line),
			length(Line, NumberOfLines).

	% The rule above will display the number of lines which pass through a stop.
	% numberOfLines(Stop, NumberOfLines) will return a value based on the variable Line.
	% the answer will be displayed as the length of Line within a new variable called NumberOfLines.

/*===================*/

% Route between two stops
		route(Stop1, Stop2, Route):-													/*Main rule*/
				calcRoute(Stop1, Stop2, [], Return),
				reverse([Stop2|Return],Route).

		calcRoute(Stop1, Stop2, Temp, Route):-
				adjacent(Stop1, Stop2),
				\+member(Stop1, Temp),
				Route = [Stop1|Temp].

		calcRoute(Stop1, Stop2, Temp, Route):-						/*Recursive rule */
				adjacent(Stop1,Next),
				Next \== Stop2,
				\+member(Stop1, Temp),
				calcRoute(Next, Stop2, [Stop1|Temp], Route).

	% This rule is the most complex of the code, it calls a function that calculates the route.
	% To do that, the calcRoute function checks if both stations are already next to each other,
	% if they are not, it starts the recursive rule.
	% The recursive rule adds the next stop that is adjacent to Stop1 to the Route, then checks if it is Stop2.
	% If it is not, it save the new established route as Temp and continues with the next adjacent stop.
	% If it is, the function exits and return the route. Sadly the route is displayed backwards for the user,
	% so the reverse function reverses it in the main rule before the final display

/*===================*/

% Basic Route Time Rule
		routeTime(Stop1, Stop2, Route, RouteTime):-  	/*routeTime is called a user called method.*/
			route(Stop1, Stop2, Route),				/*route(Stop1, Stop2, Route) inherits the route algorithm above.*/
			length(Route, Time),							/*Length(Route, Time) returns length of the route and the time.*/
			RouteTime is (Time -1) * 7.						/*Returns the time it takes to travel.*/

	% This rule outputs a route specified by the user using the route rule stated above
	%	then calculates the time needed to travel.
	%	For this example we chose a mean of 7 minutes between 2 stops,
	%	which makes 8 minutes per stop minus the one you are already at.
