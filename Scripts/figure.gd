class_name Figure
extends Sprite2D

var Team := -1 

var PosX: int:
	set(val):
		position.x = 25 + 50 * val
	get:
		return (position.x - 25) / 50
		
var PosY: int:
	set(val):
		position.y = 25 + 50 * val
	get:
		return (position.y - 25) / 50

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and $"../../Cursor".visible  and GlobalVar.ActivePlayer == Team:
		if position == $"../../Cursor".position:
			
			if GlobalVar.ActiveFigure==self:
				GlobalVar.ActiveFigure=null
				$"../../../Board".deleteMarks()
				$"../../Glow".hide()
				return
				
				
			GlobalVar.ActiveFigure=self
			$"../../Glow".glow(position.x,position.y)
			
			var Pos: Array[Array] = [[PosX,PosY]]
			$"../../../Board".deleteMarks()
			$"../../../Board".marking(Pos,GlobalVar.Roll)
			
	
