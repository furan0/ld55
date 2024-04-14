class_name CircleDrawer
extends Line2D


@export var n_points := 20
@export var radius := 100.0


var to_display = 0 :
	get:
		return to_display
	set(value):
		to_display = value
		var to_draw = []
		for i in range(min(to_display,n_points)):
			var theta = 2 * PI * i/n_points 
			to_draw += [Vector2(cos(theta),sin(theta)*0.8)*radius]
		points = PackedVector2Array(to_draw)
		if to_display >= n_points:
			closed = true
		else :
			closed = false

var drawing = false
var stop_draw = true


func draw_my_circle():
	get_tree().create_tween().tween_property(self,"to_display",n_points,0.2)

func undraw():
	get_tree().create_tween().tween_property(self,"to_display",0,0.2)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
