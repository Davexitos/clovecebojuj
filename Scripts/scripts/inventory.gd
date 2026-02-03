extends Sprite2D

var inventory = [
	#gem1-gem2-gem3-gem4-figure
	[0,0,0,0,0], #plBlue
	[0,0,0,0,0], #plRed
	[0,0,0,0,0], #plGreen
	[0,0,0,0,0]  #plYelow
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func updateInventory(player):
	$Gem1.text = str(inventory[player][0])
	$Gem2.text = str(inventory[player][1])
	$Gem3.text = str(inventory[player][2])
	$Gem4.text = str(inventory[player][3])
	$Figure.text = str(inventory[player][4])


func _add_to_inventory(gem: int,player:int,val:int) -> void:
	inventory[player][gem] += val
	updateInventory(player)
