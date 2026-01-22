extends Node2D
enum players {blue,red,green,yelow}

@export var ActivePlayer: players = players.blue
@export var nextTurnLimit = false

var rng = RandomNumberGenerator.new()

#Bude se gemu omezený počet? = když protihráč sebere červrny -> menší šance ho znovu získat
#Uvidí hráči gemi soupeřů

# 0_Empty 1-4_players 5_wizards 6-9_gems
# -1 -2 -3 -4 -5 -6 path finding
var Map:Array[Array] = [
	[1,0,1,0,0,0,0,0,0,0,0,0,0,0,2,0,2],
	[0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0],
	[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,5,0,0,0,5,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,5,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,5,0,0,0,0,0,5,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3],
	[0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0],
	[4,0,4,0,0,0,0,0,0,0,0,0,0,0,3,0,3]
	]

#Zatím není motřeba. Možno smazat
var Figures = [
	[], #Blue
	[], #Red
	[], #Green
	[], #Yelow
	
	[], #Mage
]
var Gems = []
var Inventory = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVar.ActivePlayer =  ActivePlayer
	rollDice()
	
	for row in len(Map):
		for col in len(Map[row]):
			var val: int = Map[row][col]
			if val == 0:
				continue
			elif val > 0 and val < 5:
				var newFigure = Soldier.new(val-1)
				newFigure.PosX = col
				newFigure.PosY = row
				$Figure.add_child(newFigure)
				Figures[val-1].append(newFigure)
			elif val == 5:
				var newFigure = Mage.new()
				newFigure.PosX = col
				newFigure.PosY = row
				$Figure.add_child(newFigure)
				Figures[4].append(newFigure)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NextTurn"):
		nextTurn()

enum {X,Y}

func marking(Positions: Array[Array], maxDistance: int, distance: int = 1):
	if distance > maxDistance:
		return
	
	var NextPos: Array[Array]
	
	for pos in Positions:
		var newX = pos[X]+1
		var newY = pos[Y]+1
		#Check right bottom	
		if pos[X] < 16 and pos[Y] < 16 and Map[newY][newX] == 0:
			Map[newY][newX] = distance * -1
			NextPos.append([newX,newY])
			$Marks.add_child(Mark.new(newX,newY,distance))
		#Check left bottom
		newX = pos[X]-1
		newY = pos[Y]+1
		if pos[X] > 0 and pos[Y] < 16 and Map[newY][newX] == 0:
			Map[newY][newX] = distance * -1
			NextPos.append([newX,newY])
			$Marks.add_child(Mark.new(newX,newY,distance))
		#Check left top
		newX = pos[X]-1
		newY = pos[Y]-1
		if pos[X] > 0 and pos[Y] > 0 and Map[newY][newX] == 0:
			Map[newY][newX] = distance * -1
			NextPos.append([newX,newY])
			$Marks.add_child(Mark.new(newX,newY,distance))
		#Check right top
		newX = pos[X]+1
		newY = pos[Y]-1
		if pos[X] < 16 and pos[Y] > 0 and Map[newY][newX] == 0:
			Map[newY][newX] = distance * -1
			NextPos.append([newX,newY])
			$Marks.add_child(Mark.new(newX,newY,distance))
			
	marking(NextPos, maxDistance, distance+1)
		
func deleteMarks():
	for i in $Marks.get_children():
		$Marks.remove_child(i)
		
	for row in len(Map):
		for col in len(Map[row]):
			if Map[row][col] < 0:
				Map[row][col] = 0
		
func nextTurn():
	if GlobalVar.Roll > 0 and nextTurnLimit:
		return
	
	GlobalVar.ActivePlayer += 1
	rollDice()
	$Glow.hide()
	deleteMarks()
	
func _on_button_pressed() -> void:
	nextTurn()

func rollDice():
	GlobalVar.Roll = rng.randi_range(1,6)
	$Dice/Num.text = str(GlobalVar.Roll)
	
func move(PosX:int, PosY:int, subRoll: int):
	deleteMarks()
	
	Map[GlobalVar.ActiveFigure.PosY][GlobalVar.ActiveFigure.PosX] = 0
	Map[PosY][PosX] = GlobalVar.ActivePlayer+1
		
	GlobalVar.ActiveFigure.PosX=PosX
	GlobalVar.ActiveFigure.PosY=PosY
	GlobalVar.Roll -= subRoll
	$Dice/Num.text = str(GlobalVar.Roll)
