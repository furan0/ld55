class_name  Rig2D
extends Node2D

var _color_target = Color.AQUA

@export var animator : AnimationPlayer
@export var muppet : Node2D
@export var key_frame : Node2D
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
	set_color(_color_target)
