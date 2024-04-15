extends Area2D
class_name MusicTrigger

@export var isMusicIntense := true
@export var isOneShot = true

var isDisplaying := false

signal triggerFinished()
signal triggerStarted()

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body : Node2D):
	if isDisplaying:
		return
	if body is Wololo && body.faction == Character.EFaction.BLUE:
		triggerStarted.emit()
		playMusic()

func playMusic():
	if isMusicIntense:
		%GameManager.get_node("musique_manager").fade_to_intense()
	else:
		%GameManager.get_node("musique_manager").fade_to_calme()
	
	triggerFinished.emit()
	if isOneShot:
		queue_free()
