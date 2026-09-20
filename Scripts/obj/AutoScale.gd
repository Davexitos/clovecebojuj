class_name AutoScale
extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	resize()

func resize():
	#Get window size
	var x = DisplayServer.window_get_size().x
	var y = DisplayServer.window_get_size().y
	
	if x/16.0 > y/9.0: #Scale by Y
		scale = Vector2(y/1080.0,y/1080.0)
	else: #Scale by X
		scale = Vector2(x/1920.0,x/1920.0)
		
	GlobalVar.scale = scale.x
