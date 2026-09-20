extends Node2D

func _on_back_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://Maps/MultiPlayerMenu.tscn")

func _ready() -> void:
	if GlobalVar.multiplayer.is_server():
		$AutoScale/Num.text = str(4-GlobalVar.Pid_Array.count(0))
