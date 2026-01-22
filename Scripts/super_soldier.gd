extends Figure
class_name SuperSoldier

func _init(team:int) -> void:
	texture = load("res://Sprites/Figure.png")
	hframes = 5
	vframes = 2
	frame = 5 + team
	Team = team
