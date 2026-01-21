extends Figure
class_name Mage

func _init() -> void:
	texture = load("res://Sprites/Figure.png")
	hframes = 5
	vframes = 2
	frame = 4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
