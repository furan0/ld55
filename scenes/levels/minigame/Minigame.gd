extends Node2D
class_name Minigame
## Minigame main class for the conversion mechanism

@export var delayBeforeDestruction := 0.2

var callback : Callable

func setCallback(callback_ : Callable):
	callback = callback_

func action_just_press():
	# To be overriden by children
	pass

func runMinigame():
	# Todo for each child
	#Dummy example here
	print ("Start minigame")
	get_tree().create_timer(1.0).timeout.connect(terminateMinigame.bind(true))

func terminateMinigame(successStatus : bool):
	print ("End minigame")
	if callback != null:
		callback.call(successStatus)
	
	get_tree().create_timer(delayBeforeDestruction).timeout.connect(queue_free)
