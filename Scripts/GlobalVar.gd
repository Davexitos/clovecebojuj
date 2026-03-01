extends Node

var Autority
var loby: = false
var win
var scale : float= 1.0
var isFight = false
var Roll := 0
var ActiveFigure

var ActiveTeams = [0,1,2,3]
var Pid_Array :Array[int] = [0,0,0,0]
		
var ActivePlayer := 0:
	set(val):
		if val > len(ActiveTeams)-1:
			ActivePlayer = 0
		else:
			ActivePlayer = val

var ActivePlayerId:
	get:
		return GlobalVar.Pid_Array[GlobalVar.GetActivePlayer]

var GetActivePlayer:
	get:
		return ActiveTeams[ActivePlayer]



func _ready() -> void:
	get_tree().set_auto_accept_quit(false)

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		multiplayer.multiplayer_peer.close()
		get_tree().quit()

func _on_peer_disconnected(pid): #code for server when client disconect
	Pid_Array[Pid_Array.find(pid)] = 0
	if !loby:
		loby = true
		toLoby.rpc()
	$"../Node2D/Loby/AutoScale/Num".text = str(4-Pid_Array.count(0))

func HostPeer(peer: ENetMultiplayerPeer):
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(new_connection)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.server_disconnected.connect(on_server_disconect)
	Pid_Array[0] = multiplayer.get_unique_id()
	set_multiplayer_authority(multiplayer.get_unique_id())
	loby=true

func on_server_disconect(): #code for all when server disconect
	var Sconn: Array[Signal]
	if get_multiplayer_authority() == 1:
		Sconn = [multiplayer.peer_connected,multiplayer.peer_disconnected,multiplayer.server_disconnected]
		Pid_Array = [0,0,0,0]
	else:
		Sconn = [multiplayer.connected_to_server,multiplayer.server_disconnected]
		get_tree().change_scene_to_file("res://Maps/MultiPlayerMenu.tscn")
		
	for x in Sconn:
		for i in x.get_connections():
			x.disconnect(i["callable"])

func ClientPeer(peer: ENetMultiplayerPeer):
	multiplayer.multiplayer_peer = peer
	multiplayer.server_disconnected.connect(on_server_disconect)
	multiplayer.connected_to_server.connect(on_join)

func on_join(): #code for peer when this client connect
	set_multiplayer_authority(multiplayer.get_unique_id())

func new_connection(pid): #code server when client connect
	print("Peer " + str(pid) + " has joined the game!")
	Pid_Array[Pid_Array.find(0)] = pid
	
	$"../Node2D/Loby/AutoScale/Num".text = str(4-Pid_Array.count(0))
	
	if Pid_Array.find(0) == -1:
		await get_tree().create_timer(0.25).timeout #wait to sychronize last player
		start.rpc()
		loby=false
	
@rpc("call_local","any_peer")
func start():
	$"../Node2D/Loby".hide()
	$"../Node2D/Scene".show()
	
@rpc("call_local","any_peer")
func toLoby():
	$"../Node2D/Loby".show()
	$"../Node2D/Scene".hide()
