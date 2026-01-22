extends Figure
class_name Soldier

func _init(team:int) -> void:
	texture = load("res://Sprites/Figure.png")
	hframes = 5
	vframes = 2
	frame = team
	Team = team
