extends VBoxContainer


func _on_join_pressed() -> void:
	var port :int = int($HBoxContainer/VBoxContainer2/BoxPort.text)
	if port == 0:
		port = 8080
		
	var ip = $HBoxContainer/VBoxContainer2/BoxIp.text
	if ip == "":
		ip = "localhost"
		
	var peer = ENetMultiplayerPeer.new()
	
	if !(port > 1023 and port < 65536):
		return
	
	peer.create_client(ip, port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
		
	GlobalMp.ClientPeer(peer)
	
	get_tree().change_scene_to_file("res://Maps/Online.tscn")

func _on_host_pressed() -> void:
	var port :int = int($HBoxContainer/VBoxContainer/BoxPort.text)
	if port == 0:
		port = 8080
		
	var peer = ENetMultiplayerPeer.new()
	
	if !(port > 1023 and port < 65536):
		return
		
	peer.create_server(port,3)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	
	GlobalMp.HostPeer(peer)
	
	get_tree().change_scene_to_file("res://Maps/Online.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Maps/Menu.tscn")
	
