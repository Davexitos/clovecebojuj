extends Label

func _ready() -> void:
	var color := ""
	match GlobalVar.win:
		0:
			color="Blue"
		1:
			color="Red"
		2:
			color="Green"
		3:
			color="Yellow"
	
	text = "Player " + color + " win
(thanks for playing >.O)"
