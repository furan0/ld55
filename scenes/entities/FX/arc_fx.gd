extends Line2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_from_a_to_b(a: Vector2, b : Vector2):
	if a.x == b.x :
		return
	var c := (a+b) / 2 + Vector2.UP * 100.0
	var pts = []
	for i in range(10):
		var x = (b.x-a.x) * i/10.0 + a.x
		var y = a.y * (x-b.x)/(a.x-b.x) * (x-c.x)/(a.x-c.x)
		y += b.y * (x-a.x)/(b.x-a.x) * (x-c.x)/(b.x-c.x)
		y += c.y * (x-a.x)/(c.x-a.x) * (x-b.x)/(c.x-b.x)
		pts += [Vector2(x,y)]
	points = PackedVector2Array(pts)
	
