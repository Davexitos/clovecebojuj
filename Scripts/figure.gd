class_name Figure
extends TileSprite

@onready var cursor = $"../../Cursor"
@onready var board = $"../../../Board"

var Team := -1 
var newG :Glow

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and !GlobalVar.isFight and GlobalVar.ActivePlayer == Team:
		var clickPos = Vector2(floor(get_global_mouse_position().x/50)*50 + 25,floor(get_global_mouse_position().y/50)*50 + 25)
		if clickPos == position:
			board.deleteMarks()
			board.actualizateContact()
			
			if GlobalVar.ActiveFigure==self:
				GlobalVar.ActiveFigure=null
				return

			
			var Pos: Array[Array] = [[PosX,PosY]]
			board.marking(Pos,GlobalVar.Roll)
			
			GlobalVar.ActiveFigure=self
			newG = Glow.new(PosX,PosY,Team)
			$"../../Glow".add_child(newG)
