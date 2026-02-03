class_name Movable
extends TileSprite

signal click
signal marking(Positions: Array[Array], distance: int)
signal glow(x: int, y: int, frm: int)

var Team = -1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click") and !GlobalVar.isFight and GlobalVar.GetActivePlayer == Team:
		var clickPos = round(get_global_mouse_position()/(50*GlobalVar.scale))*50.0
		if clickPos == position:
			click.emit()
			
			if GlobalVar.ActiveFigure==self:
				GlobalVar.ActiveFigure=null
				return
				
			var Pos: Array[Array] = [[PosX,PosY]]
			marking.emit(Pos,1)
			GlobalVar.ActiveFigure=self
			glow.emit(PosX,PosY,Team)
