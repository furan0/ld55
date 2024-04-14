extends Node2D
## handle victory and defeat UIs

@onready var animation_fond_player = $AnimationFond/AnimationFondPlayer
@onready var animation_specific_player = $AnimationSpecificPlayer
@onready var game_manager = $".."
var camera = null

@onready var sprite_victory = %SpriteVictory

@export var cameraWantedZoom := 1.0
@export var cameraZoomTime := 1.0
@export var cameraZoomWaiting := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	
	# Do ugly crap with camera
	camera = get_tree().get_first_node_in_group("camera")
	get_parent().remove_child.call_deferred(self)
	camera.add_child.call_deferred(self)
	position = Vector2.ZERO

func _onDefeat():
	match game_manager.currentGameMode:
		GameManager.EGameMode.SINGLE:
			playDefeat(Character.EFaction.RED)
		GameManager.EGameMode.ARENA:
			playArena()

func _onVictory(victor : Character):
	match game_manager.currentGameMode:
		GameManager.EGameMode.SINGLE:
			playVictory(victor)
		GameManager.EGameMode.MULTI:
			# TODO : change to multi when done
			playVictory(victor)

func playVictory(victor : Character):
	var color : Color = Character.getFactionColor(victor.faction)
	sprite_victory.material.set_shader_parameter("overridecolor",color)
	
	print ("Victory in color : " + str(color))
	_playAnimation(victor, "victory")

func playDefeat(vicFaction : Character.EFaction):
	#_playAnimation("defeat")
	pass

func playMulti(victor : Character):
	_playAnimation(victor, "multi")

func playArena():
	#_playAnimation("arena")
	pass

func _playAnimation(target : Node2D, animName : String):
	await _doCameraMove(target)
	
	show()
	
	var functor = func (_balec) :
		animation_specific_player.play(animName)
	animation_fond_player.animation_finished.connect(functor)
	animation_fond_player.play("EndAnimation")

func _doCameraMove(target : Node2D):
	# Disable camera tracking and start tween
	camera.get_parent().doTracking = false
	await get_tree().create_tween().tween_property(camera, "zoom", Vector2.ONE * cameraWantedZoom, cameraZoomTime).finished
	await get_tree().create_timer(cameraZoomWaiting).timeout
	return
