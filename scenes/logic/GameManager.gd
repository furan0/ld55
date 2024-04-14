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


func _callbackPeonDied(peon : Character):
	match peon.faction:
		Character.EFaction.BLUE:
			nbPeonsBlue -= 1
			if nbPeonsBlue <= 0:
				noMoreBluePeon.emit()
		Character.EFaction.RED:
			nbPeonsRed -= 1
			if nbPeonsRed <= 0:
				noMoreRedPeon.emit()
		Character.EFaction.GAIA:
			nbPeonsGaia -= 1
			if nbPeonsGaia <= 0:
				noMoreGaiaPeon.emit()

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

func parsePeon():
	peons = get_tree().get_nodes_in_group("peon")
	
	for peon in peons:
		peon.deadSelf.connect(_callbackPeonDied)
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
