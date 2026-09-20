extends MultiplayerSynchronizer

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

func _on_delta_synchronized() -> void:
	console()
