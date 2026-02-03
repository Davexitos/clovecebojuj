extends Node2D

signal changeContactStaus(str: String)
signal addToInventory(gem: int, player: int, val:int)
signal changeFightContact(fight)

var shift := [
	[1,1],
	[-1,1],
	[-1,-1],
	[1,-1]
]

var chance: Array[float] = [40,30,20,10]

var activeMage := [] # [Mage, contactCount]

#Geting Figure by PLAYER
var Figures = [
	[], #Blue
	[], #Red
	[], #Green
	[], #Yelow
	
	[], #Mage
]

#Geting Figure by POSITION
#Calculate distance from selected figure -> numbers
var Map = [
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
	[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

func _ready() -> void:
	var FiguresStartPos = [
		#[Type,Player,PosX,PosY]
		[Soldier,0,0,0],
		[Soldier,0,2,0],
		[Soldier,0,1,1],
		[Soldier,0,0,2],
		
		[Soldier,1,16,0],
		[Soldier,1,14,0],
		[Soldier,1,15,1],
		[Soldier,1,16,2],
		
		[Soldier,2,16,16],
		[Soldier,2,14,16],
		[Soldier,2,15,15],
		[Soldier,2,16,14],
		
		[Soldier,3,0,16],
		[Soldier,3,2,16],
		[Soldier,3,1,15],
		[Soldier,3,0,14],
		
		[Mage,4,6,8],
		[Mage,4,8,6],
		[Mage,4,10,8],
		[Mage,4,8,10],
		[Mage,4,5,5],
		[Mage,4,5,11],
		[Mage,4,11,5],
		[Mage,4,11,11],
	]
	
	for i in FiguresStartPos:
		var figure = i[0]
		var player = i[1]
		var posX = i[2]
		var posY = i[3]
		var newFigure = figure.new(posX,posY,player)
		addFigure(newFigure)

func addFigure(newFigure): #add Figure to board and arrays
	$Figures.add_child(newFigure)
	Map[newFigure.PosY][newFigure.PosX] = newFigure
	Figures[newFigure.Team].append(newFigure)
	if newFigure is Movable: #connect signals
		newFigure.click.connect(deleteMarks)
		newFigure.click.connect(actualizateContact)
		newFigure.marking.connect(marking)
		newFigure.glow.connect(glow)

func removeFigure(figure): #remove Figure from board and arrays
	Map[figure.PosY][figure.PosX] = 0
	Figures[figure.Team].erase(figure)
	$Figures.remove_child(figure)

	#----IDK where to put this code T^T Its late and im tired	
	if figure.Team != 4 and len(Figures[figure.Team]) == 0:
		if figure.Team <= GlobalVar.GetActivePlayer:
			GlobalVar.ActivePlayer-=1
		GlobalVar.ActiveTeams.erase(figure.Team)
		if len(GlobalVar.ActiveTeams) < 2:
			print("Player " + str(GlobalVar.GetActivePlayer))
			get_tree().quit()
	#----

func deleteMarks(): #remove distance marks from array and board
	for i in $DistanceMarks.get_children():
		$DistanceMarks.remove_child(i)
		
	for row in len(Map):
		for col in len(Map[row]):
			if Map[row][col] is int and Map[row][col] < 0:
				Map[row][col] = 0

func isInMap(x: int, y: int, zero: bool) ->bool: #checking if is int or not on XY tile
	if x < 0 or x > 16 or y < 0 or y > 16: #checking tile overflow
		return false
	
	if Map[y][x] is int and Map[y][x] == 0: #checking tile is int
		return zero == true
	else:
		return zero == false

func marking(Positions: Array[Array], distance: int = 1):
	if distance > GlobalVar.Roll:
		return
	
	var NextPos: Array[Array]
	
	for pos in Positions:
		for i in shift:
			var newX = pos[0]+i[0]
			var newY = pos[1]+i[1]
			if isInMap(newX,newY,true):
				Map[newY][newX] = distance * -1
				NextPos.append([newX,newY])
				
				var prefab = preload("res://Prefab/Mark.tscn").instantiate()
				prefab.PosX = newX
				prefab.PosY = newY
				prefab.Value = distance
				prefab.get_child(0).text = str(distance)
				prefab.click.connect(move)
				$DistanceMarks.add_child(prefab)
				
	marking(NextPos, distance+1)

func glow(x: int, y: int, frm: int):
	$Glow.add_child(Glow.new(x,y,frm))
	
func actualizateContact():
	if GlobalVar.isFight:
		return
	
	#clean contact arrays
	var activeFight := [] # [Figure, contact1, contact2 ...]
	activeMage.clear()
	
	#clean contact efects
	cleanGlow()
		
	for player in len(Figures): #in all players
		for x in Figures[player]: #all figures -> x
			for enemy in 4: #for all enemy team 
				if enemy == x.Team or enemy == 4: #continue if team isnt enemy
					continue
				
				var fightContacts : Array[Movable]= [] #array of contactc with this figure (not for mage)
				var mageContactsCount := 0 #number of contact only for mage
				for shif in shift: #check all near tile
					var newX = x.PosX +shif[0]
					var newY = x.PosY+shif[1]
					if isInMap(newX, newY,false) and Map[newY][newX].Team == enemy: #if on tile is something and its my enemy
						$"Glow".add_child(Glow.new(x.PosX,x.PosY,player)) #make efect
						if player == 4: #player mage -> contactsCount
							mageContactsCount += 1
						else: #other players -> fight contacts array
							fightContacts.append(Map[newY][newX])
							
				#adding figure contact to big array of all contact
				if !fightContacts.is_empty():
					var newFight: Array[Movable]= []
					newFight.append(x)
					newFight.append_array(fightContacts)
					activeFight.append(newFight)
				elif mageContactsCount != 0:
					activeMage.append([x,mageContactsCount])
	
	#Set button label to next action by new contacts
	if !activeMage.is_empty():
		changeContactStaus.emit("Collect")
	elif !activeFight.is_empty():
		changeContactStaus.emit("Fight")
	else:
		changeContactStaus.emit("Next turn")
	
	changeFightContact.emit(activeFight)

func move(PosX:int, PosY:int, subRoll: int):
	
	Map[GlobalVar.ActiveFigure.PosY][GlobalVar.ActiveFigure.PosX] = 0
	Map[PosY][PosX] = GlobalVar.ActiveFigure
	
	GlobalVar.ActiveFigure.PosX=PosX
	GlobalVar.ActiveFigure.PosY=PosY
	
	if $Colectible.visible and GlobalVar.ActiveFigure.position == $Colectible.position:
		addToInventory.emit(3,GlobalVar.GetActivePlayer,1)
		$Colectible.visible = false

func activateMage():
	for x in activeMage:
		for i in x[1]:
			var rnd = randf()
			var nextChance = 0.0
			for y in len(chance):
				nextChance += chance[y]/100
				if rnd < nextChance:
					addToInventory.emit(y,GlobalVar.GetActivePlayer,1)
					break
		removeFigure(x[0])

func cleanGlow(): 	#clean contact efects
	for i in $Glow.get_children():
		$Glow.remove_child(i)
