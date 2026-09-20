extends Button

@export var nextTurnLimit = true

func _ready() -> void:
	disabled = true
	
func _change_contact_staus(stri: String) -> void:
	text= stri

func enableDisableButton() -> bool:
	var fightPlID = GlobalVar.Pid_Array[$"../Fight".fightPlayers[$"../Fight".fightActiveTeam]]
	if (GlobalVar.isFight and fightPlID == multiplayer.get_unique_id()) or (!GlobalVar.isFight and (GlobalVar.Roll == 0 or !nextTurnLimit)):
		disabled = false
		return true
	else:
		disabled = true
		return false
