extends Node


func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		multiplayer.multiplayer_peer.close()
		get_tree().quit()

func _on_peer_disconnected(pid): #code for server when client disconect
	GlobalVar.Pid_Array[GlobalVar.Pid_Array.find(pid)] = 0
	if !GlobalVar.loby:
		toLoby.rpc()
	$"../Node2D/Loby/AutoScale/Num".text = str(4-GlobalVar.Pid_Array.count(0))

func HostPeer(peer: ENetMultiplayerPeer):
	GlobalVar.MP = true
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(new_connection)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(on_server_disconect)
	GlobalVar.Pid_Array[0] = multiplayer.get_unique_id()
	set_multiplayer_authority(multiplayer.get_unique_id())
	GlobalVar.loby=true

func on_server_disconect(): #code for all when server disconect
	GlobalVar.MP = false
	var Sconn: Array[Signal]
	if get_multiplayer_authority() == 1:
		Sconn = [multiplayer.peer_connected,multiplayer.peer_disconnected,multiplayer.server_disconnected]
		GlobalVar.Pid_Array = [0,0,0,0]
	else:
		Sconn = [multiplayer.connected_to_server,multiplayer.server_disconnected]
		get_tree().change_scene_to_file("res://Maps/MultiPlayerMenu.tscn")
		
	for x in Sconn:
		for i in x.get_connections():
			x.disconnect(i["callable"])

func ClientPeer(peer: ENetMultiplayerPeer):
	GlobalVar.MP = true
	multiplayer.multiplayer_peer = peer
	multiplayer.server_disconnected.connect(on_server_disconect)
	multiplayer.connected_to_server.connect(on_join)

func on_join(): #code for peer when this client connect
	set_multiplayer_authority(multiplayer.get_unique_id())

func new_connection(pid): #code server when client connect
	print("Peer " + str(pid) + " has joined the game!")
	GlobalVar.Pid_Array[GlobalVar.Pid_Array.find(0)] = pid
	
	$"../Node2D/Loby/AutoScale/Num".text = str(4-GlobalVar.Pid_Array.count(0))
	
	if GlobalVar.Pid_Array.find(0) == -1:
		await get_tree().create_timer(0.25).timeout #wait to sychronize last player
		start.rpc()
	
@rpc("call_local","any_peer")
func start():
	$"../Node2D/Loby".hide()
	$"../Node2D/Scene".show()
	GlobalVar.loby = false
	
@rpc("call_local","any_peer")
func toLoby():
	$"../Node2D/Loby".show()
	$"../Node2D/Scene".hide()
	GlobalVar.loby = true
