extends Node2D

@export var Pid_Array: Array = GlobalVar.Pid_Array
@export var ActivePlayer: int = GlobalVar.ActivePlayer

func _on_multiplayer_synchronizer_delta_synchronized() -> void:
	GlobalVar.Pid_Array = Pid_Array
	GlobalVar.ActivePlayer = ActivePlayer
	console()



func console():
	print("")
	print("------------------------------------------------------------")
	print("")
	print("Players ID")
	print(GlobalVar.Pid_Array)
	print("Active Player ID")
	print(GlobalVar.ActivePlayerId)
	
	
	
	print("")
	print("------------------------------------------------------------")
	print("")
