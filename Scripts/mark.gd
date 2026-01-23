class_name Mark
extends TileSprite

var Value


func _init(posX: int, posY: int, val :int) -> void:
	texture = load("res://Sprites/Mark.png")
	scale = Vector2(.5,.5)
	PosY = posY
	PosX = posX
	Value = val
	
	var num = Label.new()
	num.text = str(val)
	num.modulate = Color(1.0,1.0,1.0,0.5)
	num.add_theme_font_size_override("font_size", 44)
	num.position = Vector2(-14,-32)
	add_child(num)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and $"../../Cursor".visible:
		if position == $"../../Cursor".position:
			$"../../../Board".move(PosX,PosY,Value)
