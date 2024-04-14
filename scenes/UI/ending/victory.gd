extends Node2D



@export var framerate = 10
var _iframe = 0
var imgs = []
var current_img = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	imgs = [
		$Fram1,
		$Fram2,
		$Fram4,
		$Fram3,
	]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_iframe = (_iframe + 1) % framerate
	if not(_iframe):
		current_img = (current_img + 1) % len(imgs)
		for n in imgs:
			n.visible = false
		imgs[current_img].visible = true
