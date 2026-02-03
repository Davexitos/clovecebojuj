extends Node

var win
var scale : float= 1.0
var isFight = false
var Roll := 0
var ActiveFigure : Movable

var ActiveTeams = [0,1,2,3]

		
var ActivePlayer := 0:
	set(val):
		if val > len(ActiveTeams)-1:
			ActivePlayer = 0
		else:
			ActivePlayer = val

var GetActivePlayer:
	get:
		return ActiveTeams[ActivePlayer]
