extends Node
class_name GameManager
## Handle game logic

enum EGameMode { MENU, SINGLE, MULTI, ARENA }
@export var currentGameMode := EGameMode.MENU

@export var player1 : Character = null
@export var player2 : Character = null

@export var nextLevelPath : String = "res://scenes/levels/MainMenu.tscn"
##Time before unpausing the game. Negative value to never unpause automatically
@export var timeBeforeLevelStart := 0.2

var peons := []
var nbPeonsBlue := 0
var nbPeonsRed := 0
var nbPeonsGaia := 0
signal noMoreBluePeon()
signal noMoreRedPeon()
signal noMoreGaiaPeon()

var wololos := []
signal gameEnded()
signal victory(victor : Character)
signal defeat(looser : Character)

@export_group("Spawner settings")
var spawners := []
@export var canSpawn := true
@export var spawnAtInit := false
@export var spawnLibrary : SpawnLibrary
## Spawn peons if Gaia count is lower or equal AND other threshold is met
@export var nbGaiaThres := 5
## Spawn peons if color count is lower or equal AND other threshold is met
@export var nbColorThres := 5

@export_group("Score settings")
@export var score := 0
@export var pointForKills := 100
var highScore := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set itself unpausable, then pause the game nextFrame
	process_mode = Node.PROCESS_MODE_ALWAYS
	Global.pauseGame.call_deferred()
	if (timeBeforeLevelStart >= 0.0):
		get_tree().create_timer(timeBeforeLevelStart).timeout.connect(Global.unpauseGame)
	
	# Fetch players if not set
	if currentGameMode == EGameMode.SINGLE || currentGameMode == EGameMode.ARENA:
		if player1 == null:
			player1 = %Player
	if currentGameMode == EGameMode.MULTI:
		if player1 == null:
			player1 = %Player1
		if player2 == null:
			player2 = %Player2
	
	parsePeon()
	parseWololo()
	parseSpawners()
	
	if spawnAtInit:
		initialSpawn.call_deferred()
	
	highScore = Global.getHighScore()

func _exit_tree():
	if score > highScore:
		Global.saveScore(score)

func countPeon():
	nbPeonsBlue = 0
	nbPeonsRed = 0
	nbPeonsGaia = 0
	
	for peon in peons:
		if peon.is_dead:
			continue
		match peon.faction:
			Character.EFaction.BLUE:
				nbPeonsBlue += 1
			Character.EFaction.RED:
				nbPeonsRed += 1
			Character.EFaction.GAIA:
				nbPeonsGaia += 1

func _callbackPeonDied(peon : Character):
	score += pointForKills
	
	checkIfSpawnRequired()

func _callbackWololoDied(wololo : Character):
	# a player is dead => react differently depending on the context
	print("Death of " + str(wololo))
	
	#React depending on game mode
	match currentGameMode:
		EGameMode.SINGLE:
			if wololo.faction == Character.EFaction.BLUE:
				# Main player died => defeat
				defeat.emit(wololo)
			else:
				#Other wololo died => Victory
				victory.emit(player1)
			#Anyway, send the game ended signal
			gameEnded.emit()
			
		EGameMode.MULTI:
			if wololo.faction == Character.EFaction.BLUE:
				# Player1 died => victory for player 2
				victory.emit(player2)
			else:
				# Player2 died => Victory for player 1
				victory.emit(player1)
			#Anyway, send the game ended signal
			gameEnded.emit()
		
		EGameMode.ARENA:
			if wololo.faction == Character.EFaction.BLUE:
				# Main player died => defeat
				defeat.emit(wololo)
				gameEnded.emit()
			# Game keep going on if other wololo died
			# TODO : spawn a new wololo somewhere
			else:
				checkIfSpawnRequired()

func _callbackNewCharacterCreated(carac : Character):
	if carac is Wololo:
		addWololo(carac as Wololo)
	else:
		addPeon(carac as Peon)

func parsePeon():
	peons = get_tree().get_nodes_in_group("peon")
	countPeon()
	for peon in peons:
		peon.deadSelf.connect(_callbackPeonDied)

func addPeon(peon : Peon):
	peon.deadSelf.connect(_callbackPeonDied)
	peons.append(peon)
	match peon.faction:
		Character.EFaction.BLUE:
			nbPeonsBlue += 1
		Character.EFaction.RED:
			nbPeonsRed += 1
		Character.EFaction.GAIA:
			nbPeonsGaia += 1

func parseWololo():
	wololos = get_tree().get_nodes_in_group("wololo")
	
	for wololo in wololos:
		wololo.deadSelf.connect(_callbackWololoDied)

func addWololo(wololo : Wololo):
	wololos.append(wololo)
	wololo.deadSelf.connect(_callbackWololoDied)

func parseSpawners():
	spawners = get_tree().get_nodes_in_group("spawner")
	
	for spawner in spawners:
		spawner.newCharacterCreated.connect(_callbackNewCharacterCreated)

func checkIfSpawnRequired():
	if spawners.is_empty() || spawnLibrary == null:
		return
	
	countPeon()
	
	var colorCond : bool = min(nbPeonsRed, nbPeonsBlue) <= nbColorThres
	var gaiaCond : bool = nbPeonsGaia <= nbGaiaThres
	
	print("Check spawn")
	print("=> Gaia : " + str(nbPeonsGaia))
	print("=> Blue : " + str(nbPeonsBlue))
	print("=> Red : " + str(nbPeonsRed))
	print("=> Color Cond : " + str(colorCond))
	print("=> Gaia Cond : " + str(gaiaCond))
	
	if colorCond && gaiaCond:
		#A spawn is required ! 
		print("Spawn required")
		var rng = randi() % spawners.size()
		spawners[rng].spawnGroup(spawnLibrary.getRandomGroup())

func initialSpawn():
	checkIfSpawnRequired()
	if nbPeonsGaia <= nbGaiaThres:
		get_tree().create_timer(0.3).timeout.connect(initialSpawn)
