extends AutoScale
@onready var figure_control: Node2D = $FigureControl
#@onready var mpSync = $"../.."

func _draw() -> void:
	hidenShowControlHud()
	$Cursor.mpColor()

func next():
	if !$Button.enableDisableButton():
		return
	
	figure_control.deleteMarks()
	if !figure_control.activeMage.is_empty():
		figure_control.activateMage()
	elif !$Fight.activeFight.is_empty():
		if GlobalVar.isFight == false:
			$MoveDice.visible = false
			$Shop.visible = false
			$FigureControl.cleanGlow()
			$Fight.setFight()
		else:
			var isReady = true
			for i in $Fight.fightTeamReady:
				if !i:
					isReady = false
			if isReady:
				$Fight.rollFight()
			else:
				$Fight.nextFightTurn.rpc()
	else:
		$MoveDice.visible = true
		$Shop.visible = true
		$Fight.visible = false
		$FigureControl.cleanGlow()
		nextTurn() 
	figure_control.actualizateContact()

func nextTurn():
	$MoveDice.rollDice()
	figure_control.actualizateContact()
	$Button.enableDisableButton()
	ControlToNextPlayer.rpc()

func _on_button_pressed() -> void:
	next()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NextTurn"):
		next()

@rpc("call_local","any_peer")
func ControlToNextPlayer():
	GlobalVar.isFight = false
	GlobalVar.ActivePlayer += 1
	hidenShowControlHud()

func hidenShowControlHud():
	if GlobalVar.Pid_Array[GlobalVar.ActivePlayer] == multiplayer.get_unique_id():
		$MoveDice.show()
		$Shop.show()
		$Label.hide()
	else:
		$MoveDice.hide()
		$Shop.hide()
		$Label.show()
	
