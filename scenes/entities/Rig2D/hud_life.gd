extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func set_life(new_life):
	$c.visible = new_life!=100
	var tw := get_tree().create_tween()
	tw.tween_property($c/lifered,"value",new_life,0.05).set_ease(Tween.EASE_IN)
	tw.tween_property($c/life,"value",new_life,0.4).set_ease(Tween.EASE_IN)
	
	var tw_shake := get_tree().create_tween()
	tw_shake.tween_property($c,"position",Vector2(3,7),0.1)
	tw_shake.tween_property($c,"position",Vector2(-2,0),0.1)
	tw_shake.tween_property($c,"position",Vector2(3,-7),0.1)
	tw_shake.tween_property($c,"position",Vector2.ZERO,0.1)
