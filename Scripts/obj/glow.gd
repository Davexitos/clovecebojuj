class_name Glow
extends TileSprite

# Called when the node enters the scene tree for the first time.
func _init(x: int, y: int, frm: int) -> void:
	PosX = x
	PosY = y
	#texture = load("res://Sprites/GlowSimple.png") #for web
	texture = load("res://Sprites/Glow.png")
	hframes = 5
	frame = frm
