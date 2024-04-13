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

#Child nodes
@onready var move_handler : MoveHandler = %MoveHandler

func _physics_process(_delta):
	# Handle movement
	velocity = move_handler.calculatedVelocity
	move_and_slide()
	

func setFaction(newFaction : EFaction):
	faction = newFaction
	factionChanged.emit()

func kill():
	is_dead = true
	dead.emit()
