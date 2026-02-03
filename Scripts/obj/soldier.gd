class_name Soldier
extends Movable

func _init(posX:int,posY:int,team:int) -> void:
	texture = load("res://Sprites/Figure.png")
	hframes = 5
	vframes = 2
	PosX = posX
	PosY = posY
	frame = team
	Team = team
