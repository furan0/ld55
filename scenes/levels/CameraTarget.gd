extends CharacterBody2D

@export var target : Node2D = null
@export var cameraSpeed := 300.0
@export var cameraMargin := 50.0

func setTarget(node : Node2D):
	target = node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if target == null:
		return
		
	# Handle movement
	var targetVector := target.global_position - global_position
	if targetVector.length() <= cameraMargin:
		velocity = Vector2.ZERO
	else:
		velocity = targetVector.normalized() * cameraSpeed
	move_and_slide()
	
