extends Control

var maxLife := 100.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$c/lifered.max_value = maxLife
	$c/life.max_value = maxLife

func setMaxLife(max : int):
	maxLife = max
	$c/lifered.max_value = maxLife
	$c/life.max_value = maxLife


func set_life(new_life):
	$c.visible = new_life!= maxLife
	var tw := get_tree().create_tween()
	tw.tween_property($c/lifered,"value",new_life,0.05).set_ease(Tween.EASE_IN)
	tw.tween_property($c/life,"value",new_life,0.4).set_ease(Tween.EASE_IN)
	
	var tw_shake := get_tree().create_tween()
	tw_shake.tween_property($c,"position",Vector2(3,7),0.1)
	tw_shake.tween_property($c,"position",Vector2(-2,0),0.1)
	tw_shake.tween_property($c,"position",Vector2(3,-7),0.1)
	tw_shake.tween_property($c,"position",Vector2.ZERO,0.1)
