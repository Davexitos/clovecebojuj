extends Button

@export var nextTurnLimit = true

func _ready() -> void:
	disabled = true
	
func _change_contact_staus(str: String) -> void:
	text= str

func enableDisableButton() -> bool:
	if GlobalVar.Roll > 0 and nextTurnLimit:
		disabled = true
		return false
	else:
		disabled = false
		return true
