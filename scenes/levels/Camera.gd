extends Node2D

@onready var camera_target1 = $CameraTarget1
@export var target1 : Node2D = null

func _ready():
	if target1 == null:
		target1 = %Player1
	camera_target1.setTarget(target1)
	camera_target1.get_parent().remove_child(camera_target1)
	get_tree().get_root().add_child.call_deferred(camera_target1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	global_position = camera_target1.global_position
	

