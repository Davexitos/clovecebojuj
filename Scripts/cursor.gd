extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = $"..".ActivePlayer
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var x = get_global_mouse_position().x
	var y = get_global_mouse_position().y
	
	if x > 0 and x < 850 and y > 0 and y < 850:
		position.x = floor(x/50)*50 + 25
		position.y = floor(y/50)*50 + 25
		show()
	else:
		hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NextTurn"):
		if frame == 3:
			frame = 0
		else:
			frame += 1 
