class_name Figure
extends TileSprite

@onready var cursor = $"../../Cursor"
@onready var board = $"../../../Board"

var Team := -1 
var newG :Glow

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and !GlobalVar.isFight and GlobalVar.ActivePlayer == Team:
		var clickPos = round(get_global_mouse_position()/(50*GlobalVar.scale))*50.0
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
