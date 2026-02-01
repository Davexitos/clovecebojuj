extends Node2D
enum players {blue,red,green,yelow}

@export var ActivePlayer: players = players.blue
@export var nextTurnLimit = true
@export var infinityRoll = false

var gemsCount = [0,0]
var getMage := []
var fight := []
var fightTeam = []
var fightTeamReady : Array[bool]= [false,false]
var fightActiveTeam = 0 								##mess in names ActivePlayer not team
var gemsInFight = [
	[[],[],[],[]],
	[[],[],[],[]]
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
	get_tree().get_root().size_changed.connect(resize)
	resize()
	
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
	updateInventory(GlobalVar.ActivePlayer)
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
	updateInventory(GlobalVar.ActivePlayer)

func updateInventory(player):
	$Inventory/Gem1.text = str(inventory[player][0])
	$Inventory/Gem2.text = str(inventory[player][1])
	$Inventory/Gem3.text = str(inventory[player][2])
	$Inventory/Gem4.text = str(inventory[player][3])

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
				var newFight: Array[Figure]= []
				newFight.append(x)
				newFight.append_array(contacts)
				fight.append(newFight)
			elif contactsCount != 0:
				getMage.append([x,contactsCount])
				
	if !getMage.is_empty():
		$Button.text = "Collect"
	elif !fight.is_empty():
		$Button.text = "Fight"
	else:
		$Button.text = "Next Turn"

func next():
	if !enableDisableButton():
		return
	deleteMarks()
	if !getMage.is_empty():
		activateMage()
	elif !fight.is_empty():
		if GlobalVar.isFight == false:
			setFight()
		else:
			var isReady = true
			for i in fightTeamReady:
				if !i:
					isReady = false
			if isReady:
				rollFight()
			else:
				nextFightTurn()
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
	$Fight/Player2/Gems.visible = false
	
	fightTeam.clear()
	fightTeam.append(GlobalVar.ActivePlayer)
	
	var bigestFight = 0
	for i in range(1,len(fight)):
		
		if len(fight[bigestFight]) < len(fight[i]) or (len(fight[bigestFight]) <= len(fight[i]) and fight[i][0].Team != GlobalVar.ActivePlayer):
			bigestFight = i
			
	for i in $Glow.get_children():
		$Glow.remove_child(i)
	
	for i in fight[bigestFight]:
		$"Glow".add_child(Glow.new(i.PosX,i.PosY,i.Team))
		if !fightTeam.has(i.Team):
			fightTeam.append(i.Team)
		
	var dice = 0
	var dice2 = 0
	for i in len(fightTeam):
		for x in fight[bigestFight]:
			if fightTeam[i] != x.Team:
				continue
			
			if i == 0:
				var prefab = preload("res://Prefab/DiceContainer.tscn").instantiate()
				prefab.get_child(0).get_child(0).frame = fightTeam[i]
				$Fight/Player/Dices.add_child(prefab)
				dice += 1
				$Fight/Player/Dices.columns = clamp(dice,1,4)

			else:
				var prefab = preload("res://Prefab/DiceContainer.tscn").instantiate()
				prefab.get_child(0).get_child(0).frame = fightTeam[i]
				$Fight/Player2/Dices.add_child(prefab)
				dice2 += 1
				$Fight/Player2/Dices.columns = clamp(dice2,1,4)
	enableGemsAdd(0)

func enableGemsAdd(pl):
	var gems = $Fight/Player/Gems
	if pl != 0:
		gems = $Fight/Player2/Gems
	
	for i in 4:
		gems.get_child(i+1).get_child(1).disabled = true
		if inventory[fightTeam[pl]][i] > 0:
			gems.get_child(i+1).get_child(0).disabled = false
		else:
			gems.get_child(i+1).get_child(0).disabled = true
	$Button.text = "Ready"

func resize():
	var x = DisplayServer.window_get_size().x
	var y = DisplayServer.window_get_size().y
	
	if x/16.0 > y/9.0:
		scale = Vector2(y/1080.0,y/1080.0)
	else:
		scale = Vector2(x/1920.0,x/1920.0)
		
	GlobalVar.scale = scale.x


func _1_plus_pressed() -> void:
	gemToFight(0,true)

func _2_plus_pressed() -> void:
	gemToFight(1,true)

func _3_plus_pressed() -> void:
	gemToFight(2,true)

func _4_plus_pressed() -> void:
	gemToFight(3,true)

func _1_minus_pressed() -> void:
	gemToFight(0,false)

func _2_minus_pressed() -> void:
	gemToFight(1,false)

func _3_minus_pressed() -> void:
	gemToFight(2,false)

func _4_minus_pressed() -> void:
	gemToFight(3,false)

func rollFight():
	pass

func nextFightTurn():
	var pl = clamp(fightActiveTeam,0,1)
	
	for i in len(gemsInFight[pl]):
		gemsCount[pl] += len(gemsInFight[pl][i]) * (i+1)
	
	if gemsInFight[pl] != [[],[],[],[]]:
		for i in len(fightTeamReady):
			fightTeamReady[i] = false
	fightTeamReady[pl] = true
	
	var isReady = true
	for i in fightTeamReady:
		if !i:
			isReady = false
	if isReady:
		$Button.text = "Fight"
		$Fight/Player/Gems.visible = false
		$Fight/Player2/Gems.visible = false
		$Fight/Count.position = Vector2(-173.327,-0)
		$Fight.position = Vector2(708.0,-81)
		return
	
	fightActiveTeam += 1
	if fightActiveTeam >= len(fightTeam):
		fightActiveTeam = 0
		$Fight/Player/Gems.visible = true
		$Fight/Player2/Gems.visible = false
		$Fight/Count.position = Vector2(-173.327,200)
		$Fight.position = Vector2(708.0,25.0)
	else:
		$Fight/Player/Gems.visible = false
		$Fight/Player2/Gems.visible = true
		$Fight/Count.position = Vector2(-173.327,-200)
		$Fight.position = Vector2(708.0,-187.0)
		

	gemsInFight = [
	[[],[],[],[]],
	[[],[],[],[]]
]
	
	enableGemsAdd(fightActiveTeam)
	updateInventory(fightTeam[fightActiveTeam])
	
	
func gemToFight(val:int, plus:bool):
	var gems = $Fight/Player2/Gems
	var countLabel = $Fight/Count/PL2
	var Pl = 1
	
	if fightActiveTeam == 0:
		gems = $Fight/Player/Gems
		countLabel = $Fight/Count/PL1
		Pl = 0
		
	if plus:
		var prefab = preload("res://Prefab/GemButton.tscn").instantiate()
		prefab.get_child(0).frame = val
		gems.get_child(0).add_child(prefab)
		gemsInFight[Pl][val].append(prefab)
		inventory[fightTeam[fightActiveTeam]][val] -= 1
		if inventory[fightTeam[fightActiveTeam]][val] <= 0:
			gems.get_child(val+1).get_child(0).disabled = true
		gems.get_child(val+1).get_child(1).disabled = false
	else:
		gems.get_child(0).remove_child(gemsInFight[Pl][val][-1])
		gemsInFight[Pl][val].remove_at(len(gemsInFight[Pl][val])-1)
		inventory[fightTeam[fightActiveTeam]][val] += 1
		if len(gemsInFight[Pl][val]) == 0:
			gems.get_child(val+1).get_child(1).disabled = true
		gems.get_child(val+1).get_child(0).disabled = false
			
	var count = 0
	for i in len(gemsInFight[Pl]):
		count += len(gemsInFight[Pl][i]) * (i+1)
			
	if fightActiveTeam == 0:
		countLabel.text = "+" + str(count + gemsCount[0])
	else:
		countLabel.text = "+" + str(count + gemsCount[1])
	
	updateInventory(fightTeam[fightActiveTeam])
