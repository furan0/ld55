class_name  Rig2D
extends Node2D

@export var color_target = Color.AQUA
@export var blink_time := 3;

@export_group("HUD param")
@export var hud_offset : Vector2
const hud := preload("res://scenes/entities/Rig2D/hud_life.tscn")
var local_hud

var animator : AnimationPlayer
var muppet : Node2D
var key_frame : Node2D

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
	#_override_mat(muppet)
	#_override_mat(key_frame)
	_override_mat(self)
	if has_node("shadow"):
		$shadow.use_parent_material = false
	update_color()

	# putting HUD
	local_hud = hud.instantiate()
	add_child(local_hud)
	local_hud.position = hud_offset
	
	# Connect onfaction change
	get_parent().get_parent().factionChanged.connect(update_color)

func _process(_delta):
	z_index = int(global_position.y/10.0)
	
func _physics_process(_delta):
		scale = Vector2(-1,1) if get_parent().get_parent().currentDirection.x > 0.0 else Vector2.ONE

func on_pv_change(new_pv):
	local_hud.set_life(new_pv)
	call_deferred("do_blink")
	
func do_blink():
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

func dead():
	for i in range(5):
		for j in range(5):
			await get_tree().physics_frame
		material.set_shader_parameter("blink_color",Color(Color.BLACK,(i)/5.0));

func update_color():
	if not(get_parent().get_parent() is Character):
		set_color(color_target)
		return
	var team := get_parent().get_parent().faction as Character.EFaction
	set_color(Character.getFactionColor(team))
