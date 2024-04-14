extends Node
class_name GameManager
## Handle game logic

enum EGameMode { MENU, SINGLE, MULTI, ARENA }
@export var currentGameMode := EGameMode.MENU

var player1 : Character = null
var player2 : Character = null

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
signal defeat()

# Called when the node enters the scene tree for the first time.
func _ready():
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
				defeat.emit()
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
				defeat.emit()
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
