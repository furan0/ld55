extends Area2D
class_name TextTrigger

@export var texts : Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body : Node2D):
	pass
