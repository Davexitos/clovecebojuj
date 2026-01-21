class_name Figure
extends Sprite2D

signal Glow(x: int,y: int)

var Team := -1 

var PosX: int:
	set(val):
		position.x = 25 + 50 * val
		
var PosY: int:
	set(val):
		position.y = 25 + 50 * val

func _init() -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and GlobalVar.ActivePlayer == Team:
		if position == $"../../Cursor".position:
			$"../../Glow".glow(position.x,position.y)
