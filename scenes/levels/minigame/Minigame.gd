extends Node2D
class_name Minigame
## Minigame main class for the conversion mechanism

var callback : Callable

func setCallback(callback_ : Callable):
	callback = callback_

func runMinigame():
	# Todo for each child
	#Dummy example here
	print ("Start minigame")
	get_tree().create_timer(1.0).timeout.connect(terminateMinigame.bind(true))

func terminateMinigame(successStatus : bool):
	print ("End minigame")
	if callback != null:
		callback.call(successStatus)
	queue_free()
