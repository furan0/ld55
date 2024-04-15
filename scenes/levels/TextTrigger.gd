extends Area2D
class_name TextTrigger

@export var texts : Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

func displayText(player : Node2D):
	pass
	
func _on_body_entered(body : Node2D):
	if body is Wololo && body.faction == Character.EFaction.BLUE:
		
