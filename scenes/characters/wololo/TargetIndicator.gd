extends Node2D

var currentTarget : Node2D = null;
@export var pulse_frame := 10
var current_size_is_big = true
var current_frame = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if currentTarget != null:
		global_position = currentTarget.global_position

func _physics_process(_delta):
	current_frame = (current_frame + 1) % pulse_frame
	if (current_frame == 0):
		if current_size_is_big :
			current_size_is_big = false
			$Circle.width = 30
		else:
			$Circle.width = 10
			current_size_is_big = true

func attachTarget(target : Node2D):
	currentTarget = target

func modulateColor(color : Color):
	modulate = color
