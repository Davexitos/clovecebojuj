extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	z_index = 100


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func glow(x: int,y: int):
	position.x = x
	position.y = y
	frame = GlobalVar.ActivePlayer
	show()
