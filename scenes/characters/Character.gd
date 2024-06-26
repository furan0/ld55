extends CharacterBody2D
class_name Character

## Handle lifecyle
var is_dead := false
signal dead()
signal deadSelf(me : Character)

## Faction handling 
enum EFaction {BLUE, RED, GAIA}
## Listen to this player input 
@export var faction : EFaction = EFaction.GAIA
@export var can_be_converted : bool = true

signal factionChanged()

static func getFactionColor(faction_ : EFaction) -> Color:
	match faction_:
		EFaction.BLUE:
			return Color.ROYAL_BLUE
		EFaction.RED:
			return Color.BROWN
		EFaction.GAIA:
			return Color.PEACH_PUFF
	return Color.PEACH_PUFF

# life & hitpoints
@export var MAX_HEALTH := 100
@onready var health := MAX_HEALTH
@export var invicible := false
signal hurt()
signal lifeChanged(newValue : int)

#Child nodes
@onready var move_handler : MoveHandler = %MoveHandler
@onready var state_machine = %StateMachine

#Minimal distance for considering that we traveled somewhere...
var MIN_TRAVEL_MOVE : float = 1.0

# Direction curently looked by this character
var currentDirection : = Vector2.ZERO

func _ready():
	state_machine.set_expression_property("isMoving", false)
	can_be_converted = faction == EFaction.GAIA # New Idea

func _physics_process(_delta):
	# Handle movement
	velocity = move_handler.calculatedVelocity
	move_and_slide()
	
	# Calculate direction
	if velocity != Vector2.ZERO:
		currentDirection = velocity.normalized()

func _process(_delta):
	state_machine.set_expression_property("isMoving", get_position_delta().length() > MIN_TRAVEL_MOVE)

func setFaction(newFaction : EFaction):
	can_be_converted = false
	faction = newFaction
	factionChanged.emit()
	

func kill():
	is_dead = true
	dead.emit()
	deadSelf.emit(self)

func hit(damage : int):
	if invicible || is_dead:
		return
	else:
		health = max(health - damage, 0)
		hurt.emit()
		lifeChanged.emit(health)
		
		if health == 0:
			# We are dead...
			kill()

func lookAt(direction : Vector2):
	currentDirection = direction
