class_name TileSprite
extends Sprite2D

var PosX: int:
	set(val):
		position.x = 50 * val - 400
	get:
		return (position.x + 400) / 50 
		
var PosY: int:
	set(val):
		position.y = 50 * val - 400
	get:
		return (position.y + 400) / 50 
