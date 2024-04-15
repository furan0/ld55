extends Node2D

@onready var game_manager = %GameManager
var player : Wololo

@onready var peonTuto = $"Tuto Assets/SwordTuto"
@export var awaitBeforeStart := 0.5
@onready var target1 = $"Tuto Assets/Target1"
@onready var dialog1 = $"Tuto Assets/dialog1"
@onready var dialog2 = $"Tuto Assets/dialog2"
@onready var dialog3 = $"Tuto Assets/dialog3"
@onready var dialog4 = $"Tuto Assets/dialog4"
@onready var dialog5 = $"Tuto Assets/dialog5"
@onready var dialog6 = $"Tuto Assets/dialog6"
@onready var dialog7 = $"Tuto Assets/dialog7"

@export var awaitAfterHurt := 0.5

# Called when the node enters the scene tree for the first time.
func _ready():
	tutoSetup.call_deferred()
	doTuto.call_deferred()
	

func tutoSetup():
	if peonTuto == null:
		return
	
	print("tuto setup")
	
	# On desactive les mouvements du perso
	player = game_manager.player1
	player.get_node("MoveHandler").canMove = false
	player.state_machine.set_expression_property("blockConversion", true)
	player.state_machine.set_expression_property("blockSelection", true)
	
	# On desactive l'attack du peon
	peonTuto.get_node("AttackHandler").isLookingForTarget = false
	peonTuto.get_node("MoveHandler").current_speed = 600.0

func finTuto():
	print("Fin tuto")
	
	player.get_node("MoveHandler").canMove = true
	player.state_machine.set_expression_property("blockConversion",false)
	player.state_machine.set_expression_property("blockSelection",false)
	
	peonTuto.get_node("AttackHandler").isLookingForTarget = true
	
func doTuto():
	if peonTuto == null:
		return
	
	print("tuto start")
	
	# On attends un peu
	await get_tree().create_timer(awaitBeforeStart).timeout
	
	# On afiche le texte 1
	dialog1.displayText(player)
	await dialog1.triggerFinished
	
	# On avance le mec et attends fin mvt
	if target1 != null:
		peonTuto.get_node("MoveHandler").moveTo(target1.global_position)
		await peonTuto.get_node("StateMachine/MainState/Alive/Movement/Stopped").state_entered
	peonTuto.get_node("MoveHandler").current_speed = peonTuto.get_node("MoveHandler").MAX_SPEED
	

	# On afiche le texte 2
	dialog2.displayText(player)
	await dialog2.triggerFinished
	
	# On lance l'attaque du mec 
	peonTuto.get_node("AttackHandler").isLookingForTarget = true
	peonTuto.get_node("AttackHandler").lookForTarget()
	await peonTuto.get_node("StateMachine/MainState/Alive/Status/Attacking/AttackAction/PostAttack").state_entered
	
	peonTuto.get_node("AttackHandler").isLookingForTarget = false
	peonTuto.get_node("AttackHandler").stopAllAttack()
	
	await get_tree().create_timer(awaitAfterHurt).timeout
	
	# On lance la musique énervée
	game_manager.get_node("musique_manager").fade_to_intense()
	
	# On afiche le texte 3
	dialog3.displayText(player)
	await dialog3.triggerFinished
	
	# On afiche le texte 4 & active convertion
	player.state_machine.set_expression_property("blockConversion",false)
	dialog4.displayText(player)
	await dialog4.triggerFinished
	
	#Wait for convertion
	await player.get_node("StateMachine/MainState/Alive/Convertion/ConversionSucc").state_exited
	
	dialog5.displayText(player)
	await dialog5.triggerFinished
	
	# Let the player move & wait for trigger 6
	player.get_node("MoveHandler").canMove = true
	await dialog6.triggerStarted
	player.get_node("MoveHandler").canMove = false
	await dialog6.triggerFinished
	
	# On afiche le texte 7 & active selection
	player.state_machine.set_expression_property("blockSelection", false)
	dialog7.displayText(player)
	
	await player.get_node("StateMachine/MainState/Alive/Selection/SelectingUnits").state_entered
	finTuto()
