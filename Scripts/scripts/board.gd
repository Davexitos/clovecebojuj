extends Node2D
@onready var figure_control: Node2D = $FigureControl

var figtUI = false

func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	resize()
	
func resize():
	#Get window size
	var x = DisplayServer.window_get_size().x
	var y = DisplayServer.window_get_size().y
	
	if x/16.0 > y/9.0: #Scale by Y
		scale = Vector2(y/1080.0,y/1080.0)
	else: #Scale by X
		scale = Vector2(x/1920.0,x/1920.0)
		
	GlobalVar.scale = scale.x

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
