extends CharacterBody2D


signal move

@export var SPEED := 300.0
var acc = 0.4
var current_speed := SPEED
var direction = Vector2.ZERO

var is_dead := false

func _physics_process(delta):
	if is_dead:
		return
		
	var new_dir = Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		new_dir += Vector2.LEFT
	if Input.is_action_pressed("right"):
		new_dir += Vector2.RIGHT
	if Input.is_action_pressed("up"):
		new_dir += Vector2.UP
	if Input.is_action_pressed("down"):
		new_dir += Vector2.DOWN
	direction = lerp(direction,new_dir,acc)  # Un peu d'inertie
	if new_dir != Vector2.ZERO:
		move.emit()
		velocity = direction.normalized() * current_speed
	else:
		velocity = Vector2.ZERO
	#$pivot.look_at(global_position + direction.normalized())
	move_and_slide()

