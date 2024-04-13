class_name CircleDrawer
extends Line2D


@export var n_points := 20
@export var radius := 100.0

var to_draw = []

var drawing = false
var stop_draw = true


func draw_my_circle():
	drawing = true
	closed = false
	to_draw = []
	for i in range(n_points):
		var theta = 2 * PI * i/n_points 
		to_draw += [Vector2(cos(theta),sin(theta))*radius]
		points = PackedVector2Array(to_draw)
		if i % 5:
			await get_tree().physics_frame
		#if stop_draw:
			#stop_draw = false
			#drawing = false
			#undraw()
			#break
	drawing = false
	closed = true

func undraw():
	if len(to_draw) == 0 or drawing:
		stop_draw = true
		return
	closed = false
	for i in range(n_points):
		to_draw.pop_back()
		points = PackedVector2Array(to_draw)
		await get_tree().physics_frame

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
