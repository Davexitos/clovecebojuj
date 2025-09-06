extends Node2D

#Bude se gemu omezený počet? = když protihráč sebere červrny -> menší šance ho znovu získat
#Uvidí hráči gemi soupeřů
@export var ActivePl = 1
var FocusFigure = false
var FocusFigurePos = Vector2(0,0)

var Figures = []
var Gems = []
var Inventory
# 0_Empty 1-4_players 5_wizards 6-9_gems
var Map:Array[Array] = [
	[1,0,1,0,0,0,0,0,0,0,0,0,0,0,2,0,2],
	[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,5,0,9,0,5,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
	[0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0],
	[4,0,4,0,0,0,0,0,0,0,0,0,0,0,3,0,3]
	]
@export var TileSize = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reloadMap()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Click"):
		var Tile = get_global_mouse_position()
		if Tile.x < 0 or Tile.x > 17*TileSize or Tile.y < 0 or Tile.y > 17*TileSize:
			return
		Tile = Vector2(floor(Tile.x/TileSize),floor(Tile.y/TileSize))
		
		#SecondClick
		if Map[Tile.y][Tile.x] == 0 and FocusFigure:
			Map[FocusFigurePos.y][FocusFigurePos.x] = 0
			Map[Tile.y][Tile.x] = ActivePl
			FocusFigurePos = Tile
			reloadMap()
			#FocusFigure = false
		#FirstClick
		elif Map[Tile.y][Tile.x] == ActivePl:
			FocusFigure = true
			FocusFigurePos = Tile
	
	if event.is_action_pressed("NextTurn"):
		FocusFigure = false
		ActivePl+=1
		if ActivePl > 4:
			ActivePl -= 4
		
func reloadMap():
	#ClearTile
	for i in Figures:
		self.remove_child(i)
	for i in Gems:
		self.remove_child(i)
	Figures = []
	Gems = []
	
	#AddToTile
	for y in len(Map):
		for x in len(Map[y]):
			if Map[y][x] == 0:
				continue
			if Map[y][x] < 6:
				var Figure = Sprite2D.new()
				Figure.texture = load('res://Sprites/Figure.png')
				Figure.hframes = 5
				Figure.frame = Map[y][x]-1
				Figure.position = Vector2(x*TileSize+TileSize/2,y*TileSize+TileSize/2)
				Figures.append(Figure)
				add_child(Figure)
			else:
				var Gem = Sprite2D.new()
				Gem.texture = load('res://Sprites/Gems.png')
				Gem.hframes = 4
				Gem.frame = Map[y][x]-6
				Gem.scale = Vector2(0.5,0.5)
				Gem.position = Vector2(x*50+25,y*50+25)
				Gems.append(Gem)
				add_child(Gem)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
