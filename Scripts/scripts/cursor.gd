extends Sprite2D

func _ready() -> void:
	hide()

func mpColor() -> void:
	frame = GlobalVar.Pid_Array.find(multiplayer.get_unique_id())

func _input(event):
	if event is InputEventMouseMotion:
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
