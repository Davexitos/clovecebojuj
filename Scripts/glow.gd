extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	z_index = 100

func glow(x: int,y: int):
	position.x = x
	position.y = y
	frame = GlobalVar.ActivePlayer
	show()
