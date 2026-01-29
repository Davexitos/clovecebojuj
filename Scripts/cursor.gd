extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = $"..".ActivePlayer
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x = get_global_mouse_position().x
	var y = get_global_mouse_position().y
	var halfWith = 425 * GlobalVar.scale
	
	if x > -halfWith and x < halfWith and y > -halfWith and y < halfWith:
		position.x = round(x/(50*GlobalVar.scale))*50.0
		position.y = round(y/(50*GlobalVar.scale))*50.0
		show()
	else:
		hide()
		
func nextTurn(val: int):
	frame = val
