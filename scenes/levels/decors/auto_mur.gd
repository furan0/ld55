extends Node2D

const pan := preload("res://scenes/levels/decors/pan_cliff.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	#trace()
	pass # Replace with function body.

func trace():
	var line := $Line2D as Line2D
	var n_pt = line.get_point_count() 
	for point_index in range(n_pt):
		var a := line.get_point_position(point_index)
		var b := line.get_point_position((point_index +1)%n_pt)
		var instance := pan.instantiate()
		add_child(instance)
		instance.get_node("CollisionShape2D").shape = instance.get_node("CollisionShape2D").shape.duplicate()
		var seg := (instance.get_node("CollisionShape2D")).shape as SegmentShape2D
		seg.a = a
		seg.b = b
