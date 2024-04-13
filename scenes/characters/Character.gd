extends CharacterBody2D
class_name Character

var is_dead := false

#Child nodes
@onready var move_handler : MoveHandler = %MoveHandler


func _physics_process(delta):
	# Handle movement
	velocity = move_handler.calculatedVelocity
	move_and_slide()
