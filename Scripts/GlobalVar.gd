extends Node

var ActivePlayer := -1:
	set(val):
		if val > 3:
			ActivePlayer = 0
		else:
			ActivePlayer = val
		$"../Board/Cursor".nextTurn(ActivePlayer)

var Roll :int
var ActiveFigure: Figure
