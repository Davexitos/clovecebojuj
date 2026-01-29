extends Node

var scale : float= 1.0
var isFight = false
var ActivePlayer := -1:
	set(val):
		if val > 3:
			ActivePlayer = 0
		else:
			ActivePlayer = val
		$"../Scene/Board/Cursor".nextTurn(ActivePlayer)

var Roll :int
var ActiveFigure: Figure
