extends Sprite2D

var inventory:
	get:
		return $"../Inventory".inventory

signal glow (x: int, y: int, frm: int)
signal changeContactStaus(str: String)
signal addToInventory(gem: int,player:int,val:int)
signal updateInventory(player:int)
signal removeFigure(figure:Movable)

var activeFight := [] # [Figure, contact1, contact2 ...]
var fightPlayers = [0,0]
var fightTeamReady = [false,false]
var fightActiveTeam = 0
var bigestFight
var gemsInFight = [
	[[],[],[],[]],
	[[],[],[],[]]
]
var gemsThisTurn = [[],[],[],[]]

func buttonHide(player,hide: bool):
	var gems
	if player == 0:
		gems = $Player/Gems
	else:
		gems = $Player2/Gems
		
	for i in range(1,5):
		gems.get_child(i).visible = !hide

@rpc("any_peer","call_local")
func setFight():
	GlobalVar.isFight = true
	visible = true
	
	$Player/Gems.visible = true
	$Player2/Gems.visible = false
	$Player/Wait.visible = false
	if GlobalVar.ActivePlayerId == multiplayer.get_unique_id():
		buttonHide(0,false)
		buttonHide(1,true)
		$Player2/Wait.visible = false
		position = Vector2(708.0,25.0)
	else:
		buttonHide(0,true)
		buttonHide(1,false)
		$Player2/Wait.visible = true
		position = Vector2(708.0,-187.0)
		$"../Label".hide()
	
	$Result.visible = false
	$Count.position = Vector2(-173.327,200)
	
	$Count/PL1.text = "+0"
	$Count/PL2.text = "+0"
	
	var toClear = [
		$Player2/Dices,
		$Player/Dices,
		$Player2/Gems/Gems,
		$Player/Gems/Gems
	]
	
	for parent in toClear:
		for children in parent.get_children():
			parent.remove_child(children)
	fightActiveTeam = 0
	fightTeamReady = [false,false]
	fightPlayers = [0,0]
	gemsInFight = [
		[[],[],[],[]],
		[[],[],[],[]]
	]
	
	
	
	fightPlayers = [GlobalVar.GetActivePlayer,0]
	bigestFight = 0
	for i in range(1,len(activeFight)):
		if len(activeFight[bigestFight]) < len(activeFight[i]) or (len(activeFight[bigestFight]) <= len(activeFight[i]) and activeFight[i][0].Team != GlobalVar.GetActivePlayer):
			bigestFight = i
			
	for i in activeFight[bigestFight]:
		glow.emit(i.PosX,i.PosY,i.Team)
		if i.Team != GlobalVar.GetActivePlayer:
			fightPlayers[1] = i.Team
			
	if GlobalVar.Pid_Array[fightPlayers[1]] != multiplayer.get_unique_id():
		setFight.rpc_id(GlobalVar.Pid_Array[fightPlayers[1]])
		
	var dice = 0
	var dice2 = 0
	for i in 2:
		for x in activeFight[bigestFight]:
			if fightPlayers[i] != x.Team:
				continue
			
			if i == 0:
				var prefab = preload("res://Prefab/DiceContainer.tscn").instantiate()
				prefab.get_child(0).get_child(0).frame = fightPlayers[i]
				$Player/Dices.add_child(prefab)
				dice += 1
				$Player/Dices.columns = clamp(dice,1,4)
			else:
				var prefab = preload("res://Prefab/DiceContainer.tscn").instantiate()
				prefab.get_child(0).get_child(0).frame = fightPlayers[i]
				$Player2/Dices.add_child(prefab)
				dice2 += 1
				$Player2/Dices.columns = clamp(dice2,1,4)
				
	enableGemsAdd(0)
	if GlobalVar.Pid_Array[fightPlayers[0]] == multiplayer.get_unique_id() or GlobalVar.Pid_Array[fightPlayers[1]] == multiplayer.get_unique_id():
		changeContactStaus.emit("Ready")
	

func enableGemsAdd(pl):
	var gems = $Player/Gems
	if pl != 0:
		gems = $Player2/Gems
	
	for i in 4:
		gems.get_child(i+1).get_child(1).disabled = true
		if inventory[fightPlayers[pl]][i] > 0:
			gems.get_child(i+1).get_child(0).disabled = false
		else:
			gems.get_child(i+1).get_child(0).disabled = true
	
func _change_fight_contact(fight: Variant) -> void:
	activeFight = fight

@rpc("any_peer","call_local")
func spawnGem(val,pl):
	var gems = $Player2/Gems/Gems
	if pl == 0:
		gems = $Player/Gems/Gems
	
	var prefab = preload("res://Prefab/GemButton.tscn").instantiate()
	prefab.get_child(0).frame = val
	gemsThisTurn[val].append(prefab)
	gems.add_child(prefab)

@rpc("any_peer","call_local")
func despawnGem(val,pl):
	var gems = $Player2/Gems/Gems
	if pl == 0:
		gems = $Player/Gems/Gems
		
	gems.remove_child(gemsThisTurn[val][-1])
	gemsThisTurn[val].remove_at(len(gemsThisTurn[val])-1)

@rpc("any_peer","call_local")
func atualizateLabel(pl):
	var countLabel = $Count/PL2
	if pl == 0:
		countLabel = $Count/PL1
		
	var count = 0
	for i in len(gemsInFight[fightActiveTeam]):
		count += len(gemsInFight[fightActiveTeam][i]) * (i+1)
	for i in len(gemsThisTurn):
		count += len(gemsThisTurn[i]) * (i+1)
	
	print(gemsInFight)
	print(gemsThisTurn)
	countLabel.text = "+" + str(count)

func gemToFight(val:int, plus:bool):
	var gems = $Player2/Gems
	
	if fightActiveTeam == 0:
		gems = $Player/Gems
		
	if plus:
		spawnGem.rpc(val,fightActiveTeam)
		addToInventory.emit(val,fightPlayers[fightActiveTeam],-1)
		if inventory[fightPlayers[fightActiveTeam]][val] <= 0:
			gems.get_child(val+1).get_child(0).disabled = true
		gems.get_child(val+1).get_child(1).disabled = false
	else:
		despawnGem.rpc(val,fightActiveTeam)
		inventory[fightPlayers[fightActiveTeam]][val] += 1
		if len(gemsThisTurn[val]) == 0:
			gems.get_child(val+1).get_child(1).disabled = true
		gems.get_child(val+1).get_child(0).disabled = false
			
	
	atualizateLabel.rpc_id(1,fightActiveTeam)
	updateInventory.emit(fightPlayers[fightActiveTeam])

@rpc("any_peer","call_local")
func nextFightTurn():
	
	if gemsThisTurn != [[],[],[],[]]:
		for i in len(fightTeamReady):
			fightTeamReady[i] = false
	fightTeamReady[fightActiveTeam] = true
	
	for i in len(gemsInFight[fightActiveTeam]):
		gemsInFight[fightActiveTeam][i] += gemsThisTurn[i]
	
	var isReady = true
	for i in fightTeamReady:
		if !i:
			isReady = false
	if isReady:
		if GlobalVar.Pid_Array[fightPlayers[0]] == multiplayer.get_unique_id() or GlobalVar.Pid_Array[fightPlayers[1]] == multiplayer.get_unique_id():
			changeContactStaus.emit("Fight")
		$Player/Gems.visible = false
		$Player2/Gems.visible = false
		$Player2/Wait.visible = false
		$Player/Wait.visible = false
		$Count.position = Vector2(-173.327,-0)
		position = Vector2(708.0,-100)
		return
	
	fightActiveTeam += 1
	if fightActiveTeam >= 2:
		fightActiveTeam = 0
		$Player/Gems.visible = true
		$Player2/Gems.visible = false
		$Count.position = Vector2(-173.327,200)
	else:
		$Player/Gems.visible = false
		$Player2/Gems.visible = true
		$Count.position = Vector2(-173.327,-200)
		
	var state: bool = (fightActiveTeam != 0)
	if GlobalVar.ActivePlayerId == multiplayer.get_unique_id():
		$Player/Wait.visible = state
	else:
		$Player2/Wait.visible = !state
	
	gemsThisTurn = [[],[],[],[]]
	
	enableGemsAdd(fightActiveTeam)
	updateInventory.emit(fightPlayers[fightActiveTeam])
	
	$"../Button".enableDisableButton()

func rollFight():
	GlobalVar.isFight = false
	var count = [0,0]
	var dice = [$Player/Dices,$Player2/Dices]
	
	for x in len(count):
		for i in len(gemsInFight[x]):
			count[x] += len(gemsInFight[x][i]) * (i+1)
			
		for i in dice[x].get_children():
			var roll = randi_range(1,6)
			i.get_child(0).text= str(roll)
			count[x] += roll
			
	$Result.visible = true
	$Result/PL1/Label.text = str(count[0])
	$Result/PL2/Label.text = str(count[1])
	
	var lose = -1
	if count[0] > count[1]:
		lose = 1
	elif count[0] < count[1]:
		lose = 0
		
	if lose != -1:
		for i in activeFight[bigestFight]:
			if i.Team == fightPlayers[lose]:
				removeFigure.emit(i)

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
