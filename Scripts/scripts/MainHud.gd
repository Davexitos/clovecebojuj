extends VBoxContainer


func _on_local_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/board.tscn")


func _on_online_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/MultiPlayerMenu.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
