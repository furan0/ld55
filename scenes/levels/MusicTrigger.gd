extends Area2D
class_name MusicTrigger

@export var isMusicIntense := true
@export var isHalfLife := false
var halfLifeTriggered := false
@export var isOneShot = true

var isDisplaying := false

signal triggerFinished()
signal triggerStarted()

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)
	if isHalfLife:
		setupHalfLife.call_deferred()

func setupHalfLife():
	var player1 = %GameManager.player1
	if player1 != null:
		player1.hurt.connect(checkLife)
	var player2 = %GameManager.player2
	if player2 != null:
		player2.hurt.connect(checkLife)

func checkLife():
	if halfLifeTriggered:
		return
		
	var player1 = %GameManager.player1
	if player1 != null && player1.health <= player1.MAX_HEALTH / 2:
		playMusic()
		halfLifeTriggered = true
		return
	
	var player2 = %GameManager.player2
	if player2 != null && player2.health <= player2.MAX_HEALTH / 2:
		playMusic()
		halfLifeTriggered = true
		return

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
