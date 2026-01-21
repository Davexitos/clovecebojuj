class_name Figure
extends Sprite2D

signal Glow(x: int,y: int)

var Team := -1 

var PosX: int:
	set(val):
		position.x = 25 + 50 * val
	get:
		return (position.x - 25) / 50
		
var PosY: int:
	set(val):
		position.y = 25 + 50 * val
	get:
		return (position.y - 25) / 50

func _init() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and GlobalVar.ActivePlayer == Team:
		if position == $"../../Cursor".position:
			$"../../Glow".glow(position.x,position.y)
			
			var Pos: Array[Array] = [[PosX,PosY]]
			$"../../../Board".deleteMarks()
			$"../../../Board".marking(Pos,6)
			
	
