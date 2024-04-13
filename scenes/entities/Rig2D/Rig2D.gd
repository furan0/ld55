class_name  Rig2D
extends Node2D

@export_group("Color param")
@export var color_target = Color.AQUA
@export var blink_time := 3;

@export_group("HUD param")
@export var hud_offset : Vector2
const hud := preload("res://scenes/entities/Rig2D/hud_life.tscn")
var local_hud

var animator : AnimationPlayer
var muppet : Node2D
var key_frame : Node2D
var _fallback_anim = "idle"

func play_by_name(anim_name_str="idle"):
	if (animator == null) or not(has_method(anim_name_str)):
		print("Cannot play anim check animator or method name")
		return
	call(anim_name_str)

func set_color(color : Color):
	material.set_shader_parameter("overridecolor",color)

func _override_mat(node : Node):
	for child in node.get_children():
		if child is Node2D:
			child.use_parent_material = true
			_override_mat(child)

func _ready():
	animator = get_node("AnimationPlayer")
	muppet = get_node("muppet")
	key_frame = get_node("keyframe")
	
	material = material.duplicate() # making the material unique.
	_override_mat(self)
	set_color(color_target)
	
	# putting HUD
	local_hud = hud.instantiate()
	add_child(local_hud)
	local_hud.position = hud_offset
	
	
func on_pv_change(new_pv):
	local_hud.set_life(new_pv)
	call_deferred("do_blink")
	
func do_blink():
	print("blink")
	muppet.scale = Vector2(1.3,0.7)
	var tw := get_tree().create_tween()
	tw.tween_property(muppet,"scale",Vector2(0.8,1.2),0.1)
	tw.tween_property(muppet,"scale",Vector2.ONE,0.1)
	material.set_shader_parameter("blink_color",Color.BLACK);
	for i in range(blink_time):
		await get_tree().physics_frame
	material.set_shader_parameter("blink_color",Color.DIM_GRAY);
	for i in range(blink_time):
		await get_tree().physics_frame
	material.set_shader_parameter("blink_color",Color.BLACK);
	for i in range(blink_time):
		await get_tree().physics_frame
	material.set_shader_parameter("blink_color",Color(Color.WHITE,0.0));
