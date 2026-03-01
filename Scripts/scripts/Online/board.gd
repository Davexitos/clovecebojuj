extends AutoScale
@onready var figure_control: Node2D = $FigureControl

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
				$Fight.nextFightTurn()
	else:
		$MoveDice.visible = true
		$Shop.visible = true
		$Fight.visible = false
		$FigureControl.cleanGlow()
		nextTurn() 
	figure_control.actualizateContact()

func nextTurn():
	GlobalVar.isFight = false
	GlobalVar.ActivePlayer += 1
	$Cursor.nextTurn(GlobalVar.GetActivePlayer)
	$MoveDice.rollDice()
	$Inventory.updateInventory(GlobalVar.GetActivePlayer)
	figure_control.actualizateContact()
	$Button.enableDisableButton()

func _on_button_pressed() -> void:
	next()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NextTurn"):
		next()

func hidenShowControlHud():
	if GlobalVar.Pid_Array[GlobalVar.ActivePlayer] == multiplayer.get_unique_id():
		$MoveDice.show()
		$Shop.show()
		$Label.hide()
	else:
		$MoveDice.hide()
		$Shop.hide()
		$Label.show()
	
