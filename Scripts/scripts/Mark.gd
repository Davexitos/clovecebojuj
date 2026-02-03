extends TileSprite

var Value
signal click(PosX:int,PosY:int,Value:int)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		var clickPos = round(get_global_mouse_position()/(50*GlobalVar.scale))*50.0
		if clickPos == position:
			click.emit(PosX,PosY,Value)
