class_name TileSprite
extends Sprite2D

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
