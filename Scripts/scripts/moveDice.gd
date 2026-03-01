extends Sprite2D

@export var infinityRoll = false
signal enableDisableButton

func _ready() -> void:
	rollDice()

func rollDice():
	if infinityRoll:
		GlobalVar.Roll = 999
		$Num.text = "X"
		return
	GlobalVar.Roll = randi_range(1,6)
	$Num.text = str(GlobalVar.Roll)

func _on_distance_marks_child_entered_tree(node: Node) -> void:
	node.click.connect(rollSub)

func rollSub(PosX:int, PosY:int, subRoll: int):
	GlobalVar.Roll -= subRoll 
	$Num.text = str(GlobalVar.Roll)
	enableDisableButton.emit()
