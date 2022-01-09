/* This program simulates routes in a simplified version of the Linz tram network */
% Here we define the tram stops

				stop(airport, [u1,s1,s2]).
				stop(suttonRoad, [u1,s3]).
				stop(eagleRoad, [u1,u2,b1]).
				stop(tulipHill, [u1]).
				stop(garettStreet, [u1,s3]).
				stop(virginStreet, [u1,s2]).
				stop(saffronRoad, [u1]).
				stop(kingStreet, [u1,u2]).
				stop(westTrainStation, [u1,u2,s1,b2]).
				stop(barnesRoad, [u2,s1]).
				stop(northEastTrainStation, [u2,s2]).
				stop(loganRoad, [u2,s3]).
				stop(springPlaza, [u2,s3]).
				stop(marchStreet, [u2,s2]).
				stop(hospital, [s1]).
				stop(liverRoad, [s1,b1]).
				stop(hazelRoad, [s1,b2]).
				stop(cityCenter, [s2]).
				stop(centralTrainStation, [s2,b1,b2]).
				stop(dillsquare, [s3,b1]).
				stop(pineStreet, [b1,b2]).

/*===================*/

% Here we check have the rules to check if two stops are adjacent to eachother
	% This first rule allows the programm to check both ways in a single command
		adjacent(X,Y):- adjacent_stops(X,Y).
		adjacent(X,Y):- adjacent_stops(Y,X).

		%u1
			adjacent_stops(airport,suttonRoad).
			adjacent_stops(suttonRoad,eagleRoad).
			adjacent_stops(eagleRoad,tulipHill).
			adjacent_stops(tulipHill,garettStreet).
			adjacent_stops(garettStreet,virginStreet).
			adjacent_stops(virginStreet,saffronRoad).
			adjacent_stops(saffronRoad,kingStreet).
			adjacent_stops(kingStreet,westTrainStation).
		%u2
			adjacent_stops(barnesRoad,northEastTrainStation).
			adjacent_stops(northEastTrainStation,loganRoad).
			adjacent_stops(loganRoad,eagleRoad).
			adjacent_stops(eagleRoad,springPlaza).
			adjacent_stops(springPlaza,marchStreet).
			adjacent_stops(marchStreet,kingStreet).
		%s1
			adjacent_stops(airport,barnesRoad).
			adjacent_stops(barnesRoad,hospital).
			adjacent_stops(hospital,liverRoad).
			adjacent_stops(liverRoad,hazelRoad).
			adjacent_stops(hazelRoad,westTrainStation).
		%s2
			adjacent_stops(airport,northEastTrainStation).
			adjacent_stops(northEastTrainStation,cityCenter).
			adjacent_stops(cityCenter,centralTrainStation).
			adjacent_stops(centralTrainStation,marchStreet).
			adjacent_stops(marchStreet,virginStreet).
		%s3
			adjacent_stops(suttonRoad,loganRoad).
			adjacent_stops(loganRoad,dillSquare).
			adjacent_stops(dillSquare,springPlaza).
			adjacent_stops(springPlaza,garettStreet).
		%b1
			adjacent_stops(eagleRoad,dillSquare).
			adjacent_stops(dillSquare,centralTrainStation).
			adjacent_stops(centralTrainStation,pineStreet).
			adjacent_stops(pineStreet,liverRoad).
		%b2
			adjacent_stops(pineStreet,hazelRoad).

/*===================*/

% Here we check if two stops are on the same line
	% Sameline
		sameline(Stop1, Stop2, Line):-
			stop(Stop1, Line1),
			stop(Stop2, Line2),
			member(Line, Line1),
			member(Line, Line2).

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
		calcRoute(Stop1, Stop2, Route):-													/*Main rule*/
				tempRoute(Stop1, Stop2, [], Return),
				reverse([Stop2|Return],Route).

		tempRoute(Stop1, Stop2, Temp, Route):-
				adjacent(Stop1, Stop2),
				\+member(Stop1, Temp),
				Route = [Stop1|Temp].

		tempRoute(Stop1, Stop2, Temp, Route):-						/*Recursive rule */
				adjacent(Stop1,Next),
				Next \== Stop2,
				\+member(Stop1, Temp),
				tempRoute(Next, Stop2, [Stop1|Temp], Route).

	% This rule is the most complex of the code, it calls a function that calculates the route.
	% To do that, the calcRoute function checks if both stations are already next to each other,
	% if they are not, it starts the recursive rule.
	% The recursive rule adds the next stop that is adjacent to Stop1 to the Route, then checks if it is Stop2.
	% If it is not, it save the new established route as Temp and continues with the next adjacent stop.
	% If it is, the function exits and return the route. Sadly the route is displayed backwards for the user,
	% so the reverse function reverses it in the main rule before the final display

/*===================*/

% Basic route time rule
		routeTime(Stop1, Stop2, Route, RouteTime):-
			calcRoute(Stop1, Stop2, Route),
			length(Route, Time),
			RouteTime is (Time -1) * 6.

	% This rule outputs a route specified by the user using the route rule stated above
	%	then calculates the time needed to travel.
	%	For this example we chose a mean of 6 minutes between 2 stops,
	%	which makes 6 minutes per stop minus the one you are already at.

/*===================*/

% Calculation of the best route
		route(Stop1, Stop2, Route):-
    		limit(1, (order_by([asc(Time)], (routeTime(Stop1, Stop2, Route, Time))))).

		route(Stop1, Stop2, Route, Time):-
    		limit(1, (order_by([asc(Time)], (routeTime(Stop1, Stop2, Route, Time))))).

	% This rule outputs the shortest and fastest route from a station to another.
	% Using basic prolog rules, it outputs the first route with the shortest time.
