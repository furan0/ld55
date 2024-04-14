extends Node2D
## handle victory and defeat UIs

@onready var animation_fond_player = $AnimationFond/AnimationFondPlayer
@onready var animation_specific_player = $AnimationSpecificPlayer


enum EEndingType {VICTORY, DEFEAT, MULTI, ARENA}
@export var currentEndingType : EEndingType = EEndingType.VICTORY

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_fond_player.animation_finished.connect(_transitionFinished)

func playEnding(endingType : EEndingType):
	currentEndingType = endingType
	animation_fond_player.play("EndAnimation")

func _transitionFinished():
	# Transition finished, now playing specific anim.
	match currentEndingType:
		EEndingType.VICTORY:
			pass

func playVictory():
	animation_specific_player.play("victory")

func playDefeat():
	animation_specific_player.play("defeat")

func playMulti():
	animation_specific_player.play("multi")

func playArena():
	animation_specific_player.play("arena")
