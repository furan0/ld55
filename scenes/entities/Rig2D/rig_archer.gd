extends "res://scenes/entities/Rig2D/rig_epee.gd"


const fx_tir := preload("res://scenes/entities/FX/arc_fx.tscn")

func attaque():
	super.attaque()
	var papa = get_parent().get_parent().get_parent()
	if papa == null or (get_parent().get_parent().get_node("AttackHandler") == null):
		return
	var target = get_parent().get_parent().get_node("AttackHandler").target
	if target == null:
		return
		
	var instance := fx_tir.instantiate()
	papa.add_child(instance)
	instance.draw_from_a_to_b(global_position,target.global_position)
	get_tree().create_tween().tween_property(instance,"modulate",Color(Color.DARK_SLATE_BLUE,0.0),0.2).finished.connect(instance.queue_free)
