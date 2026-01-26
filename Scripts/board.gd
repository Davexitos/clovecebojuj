extends Node2D
enum players {blue,red,green,yelow}

@export var ActivePlayer: players = players.blue
@export var nextTurnLimit = true
@export var infinityRoll = false

var getMage := [
	[]
]
var fight := [
	[[],[]]
]

var chance: Array[float] = [40,30,20,10]
var inventory = [
	#gem1-gem2-gem3-gem4-figure
	[0,0,0,0,0], #plBlue
	[0,0,0,0,0], #plRed
	[0,0,0,0,0], #plGreen
	[0,0,0,0,0]  #plYelow
]

var shift := [
	[1,1],
	[-1,1],
	[-1,-1],
	[1,-1]
]

#Bude se gemu omezený počet? = když protihráč sebere červrny -> menší šance ho znovu získat
#Uvidí hráči gemi soupeřů
var Figures = [
	[], #Blue
	[], #Red
	[], #Green
	[], #Yelow
	
	[], #Mage
]

# 0_Empty 1-4_players 5_wizards 6-9_gems
# -1 -2 -3 -4 -5 -6 path finding
var Map = [
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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalVar.ActivePlayer =  ActivePlayer
	rollDice()
	enableDisableButton()
	
	for row in len(Map):
		for col in len(Map[row]):
			var val: int = Map[row][col]
			if val == 0:
				continue
			elif val > 0 and val < 6:
				var newFigure = Soldier.new(val-1)
				newFigure.PosX = col
				newFigure.PosY = row
				$Figure.add_child(newFigure)
				Map[row][col] = newFigure
				Figures[val-1].append(newFigure)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("NextTurn"):
		next()

enum {X,Y}

func isInMap(x: int, y: int, zero: bool) ->bool:
	if x < 0 or x > 16 or y < 0 or y > 16:
		return false
	
	if Map[y][x] is int and Map[y][x] == 0:
		return zero == true
	else:
		return zero == false

func marking(Positions: Array[Array], maxDistance: int, distance: int = 1):
	if distance > maxDistance:
		return
	
	var NextPos: Array[Array]
	
	for pos in Positions:
		for i in shift:
			var newX = pos[X]+i[X]
			var newY = pos[Y]+i[Y]
			if isInMap(newX,newY,true):
				Map[newY][newX] = distance * -1
				NextPos.append([newX,newY])
				$Marks.add_child(Mark.new(newX,newY,distance))
				
	marking(NextPos, maxDistance, distance+1)
		
func deleteMarks():
	for i in $Marks.get_children():
		$Marks.remove_child(i)
		
	for row in len(Map):
		for col in len(Map[row]):
			if Map[row][col] is int and Map[row][col] < 0:
				Map[row][col] = 0
	

func nextTurn():
	GlobalVar.isFight = false
	GlobalVar.ActivePlayer += 1
	rollDice()
	updateInventory()
	actualizateContact()
	enableDisableButton()
	
func _on_button_pressed() -> void:
	next()

func rollDice():
	if infinityRoll:
		GlobalVar.Roll = 999
		$Dice/Num.text = "X"
		return
	GlobalVar.Roll = randi_range(1,6)
	$Dice/Num.text = str(GlobalVar.Roll)
	
func move(PosX:int, PosY:int, subRoll: int):
	
	Map[GlobalVar.ActiveFigure.PosY][GlobalVar.ActiveFigure.PosX] = 0
	Map[PosY][PosX] = GlobalVar.ActiveFigure
		
	GlobalVar.ActiveFigure.PosX=PosX
	GlobalVar.ActiveFigure.PosY=PosY
	GlobalVar.Roll -= subRoll
	$Dice/Num.text = str(GlobalVar.Roll)
	enableDisableButton()

func activateMage():
	for x in getMage:
		for i in x[1]:
			var rnd = randf()
			var nextChance = 0.0
			for y in len(chance):
				nextChance += chance[y]/100
				if rnd < nextChance:
					addGem(y)
					break
		Map[x[0].PosY][x[0].PosX] = 0
		Figures[4].erase(x[0])
		$Figure.remove_child(x[0])

func addGem(val):
	inventory[GlobalVar.ActivePlayer][val] += 1
	updateInventory()

func updateInventory():
	$Inventory/Gem1.text = str(inventory[GlobalVar.ActivePlayer][0])
	$Inventory/Gem2.text = str(inventory[GlobalVar.ActivePlayer][1])
	$Inventory/Gem3.text = str(inventory[GlobalVar.ActivePlayer][2])
	$Inventory/Gem4.text = str(inventory[GlobalVar.ActivePlayer][3])

func actualizateContact():
	if GlobalVar.isFight:
		return
	
	fight.clear()
	getMage.clear()
	
	for i in $Glow.get_children():
		$Glow.remove_child(i)
		
	for team in len(Figures):
		for x in Figures[team]:
			var contacts : Array[Figure]= []
			var contactsCount := 0
			for shif in shift:
				var newX = x.PosX +shif[X]
				var newY = x.PosY+shif[Y]
				if isInMap(newX, newY,false) and Map[newY][newX].Team != team:
					$"Glow".add_child(Glow.new(x.PosX,x.PosY,team))
					if team == 4:
						contactsCount += 1
					else:
						contacts.append(Map[newY][newX])
						
			if !contacts.is_empty():
				fight.append([[x],contacts])
			elif contactsCount != 0:
				getMage.append([x,contactsCount])
				
	if !getMage.is_empty():
		$Button.text = "Collect"
	elif !fight.is_empty():
		$Button.text = "Fight"
	else:
		$Button.text = "Next Turn"
	
	print()
	print(getMage)
	print(fight)

func next():
	if !enableDisableButton():
		return
	deleteMarks()
	if !getMage.is_empty():
		activateMage()
	elif !fight.is_empty():
		setFight()
	else:
		nextTurn() 
	actualizateContact()
	
func enableDisableButton() -> bool:
	if GlobalVar.Roll > 0 and nextTurnLimit:
		$Button.disabled = true
		return false
	else:
		$Button.disabled = false
		return true

func setFight():
	GlobalVar.isFight = true
	$Dice.visible = false
	$Shop.visible = false
	$Fight.visible = true
	
	var bigestFight = 0
	for i in range(1,len(fight)):
		if len(fight[bigestFight][1]) < len(fight[i][1]) or (len(fight[bigestFight][1]) == len(fight[i][1]) and fight[i][0][0].Team != ActivePlayer):
			bigestFight = i
			
	for i in $Glow.get_children():
		$Glow.remove_child(i)
	
	for i in fight[bigestFight]:
		for x in i:
			$"Glow".add_child(Glow.new(x.PosX,x.PosY,x.Team))
