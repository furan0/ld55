extends Node2D

var shaky : Node2D

@export var shakeIntensity := 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	shaky = get_tree().get_first_node_in_group("camera")

func doShake():
	if shaky != null:
		shaky.doShake(shakeIntensity)

func doShakeIntensity(intensity : float):
	if shaky != null:
		shaky.doShake(intensity)
