class_name  Rig2D
extends Node2D

@export var animator : AnimationPlayer
@export var muppet : Node2D
@export var key_frame : Node2D
var _fallback_anim = "idle"

func play_by_name(anim_name_str="idle"):
	if (animator == null) or not(has_method(anim_name_str)):
		print("Cannot play anim check animator or method name")
		return
	call(anim_name_str)

func _ready():
	animator = get_node("AnimationPlayer")
	muppet = get_node("muppet")
	key_frame = get_node("keyframe")
