extends Node2D

var currentTarget : Node2D = null;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if currentTarget != null:
		global_position = currentTarget.global_position

func attachTarget(target : Node2D):
	currentTarget = target

func modulateColor(color : Color):
	modulate = color
