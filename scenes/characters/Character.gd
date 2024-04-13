extends CharacterBody2D
class_name Character

## Handle lifecyle
var is_dead := false
signal dead()

## Faction handling 
enum EFaction {BLUE, RED, GAIA}
## Listen to this player input 
@export var faction : EFaction = EFaction.GAIA
signal factionChanged()

# life & hitpoints
@export var MAX_HEALTH := 100
@onready var health := MAX_HEALTH

#Child nodes
@onready var move_handler : MoveHandler = %MoveHandler
@onready var state_machine = %StateMachine

#Minimal distance for considering that we traveled somewhere...
var MIN_TRAVEL_MOVE : float = 1.0

func _ready():
	state_machine.set_expression_property("isMoving", false)

func _physics_process(_delta):
	# Handle movement
	velocity = move_handler.calculatedVelocity
	move_and_slide()

func _process(_delta):
	state_machine.set_expression_property("isMoving", get_position_delta().length() > MIN_TRAVEL_MOVE)

func setFaction(newFaction : EFaction):
	faction = newFaction
	factionChanged.emit()

func kill():
	is_dead = true
	dead.emit()
