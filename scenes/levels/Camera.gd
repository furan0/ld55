extends Node2D

@onready var screen_size = get_viewport_rect().size
@onready var camera_target1 = $CameraTarget1
@onready var camera_target2 = $CameraTarget2
@onready var camera = $Camera2D

@export var target1 : Node2D = null
@export var target2 : Node2D = null
var targetsToTrack = []
@export var doTracking := true

@export var move_speed = 0.5  	# camera position lerp speed
@export var zoom_speed = 0.25  	# camera zoom lerp speed
@export var min_zoom = 0.2  	# camera won't zoom farther than this
@export var max_zoom = 0.75  	# camera won't zoom closer than this
@export var margin = Vector2(400, 200)  # include some buffer area around targets


func _ready():
	if target1 == null:
		target1 = get_node_or_null("%Player1")
	if target2 == null:
		target2 = get_node_or_null("%Player2")
	
	if target1 != null:
		camera_target1.setTarget(target1)
		targetsToTrack.append(camera_target1)
	camera_target1.get_parent().remove_child(camera_target1)
	get_tree().get_root().add_child.call_deferred(camera_target1)
	
	if target2 != null:
		camera_target2.setTarget(target2)
		targetsToTrack.append(camera_target2)
	camera_target2.get_parent().remove_child(camera_target2)
	get_tree().get_root().add_child.call_deferred(camera_target2)

var targets = []  # Array of targets to be tracked.

func _process(_delta):
	if !targetsToTrack || !doTracking:
		return
		
	# Keep the camera centered between the targets
	var p = Vector2.ZERO
	for target in targetsToTrack:
		p += target.global_position
	p /= targetsToTrack.size()
	global_position = lerp(global_position, p, move_speed)
	
	# Find the zoom that will contain all targets
	var r = Rect2(global_position, Vector2.ONE)
	for target in targetsToTrack:
		r = r.expand(target.global_position)
	r = r.grow_individual(margin.x, margin.y, margin.x, margin.y)
	# var d = max(r.size.x, r.size.y)
	var z
	if r.size.x > r.size.y * screen_size.aspect():
		z = clamp( 1 / (r.size.x / screen_size.x), min_zoom, max_zoom)
	else:
		z = clamp(1 / (r.size.y / screen_size.y), min_zoom, max_zoom)
	
	# Set proper zoom to the Camera
	camera.zoom = lerp(camera.zoom, Vector2.ONE * z, zoom_speed)
