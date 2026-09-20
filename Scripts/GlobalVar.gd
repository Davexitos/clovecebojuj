extends Node

var MP = false
var Autority
var loby: = false
var win
var scale : float= 1.0
var isFight = false
var Roll := 0
var ActiveFigure

var ActiveTeams = [0,1,2,3]

@export var Pid_Array = [0,0,0,0]

@export var ActivePlayer := 0:
	set(val):
		if val > len(ActiveTeams)-1:
			ActivePlayer = 0
		else:
			ActivePlayer = val

var ActivePlayerId:
	get:
		return GlobalVar.Pid_Array[GlobalVar.GetActivePlayer]

var GetActivePlayer:
	get:
		return ActiveTeams[ActivePlayer]
