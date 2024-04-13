extends Rig2D

@onready var state_machine = %StateMachine
@onready var wololo = $"../.."

func _ready():
	super._ready()
	idle()
	state_machine.get_node("MainState/Alive/Movement/Move").state_entered.connect(walk)
	state_machine.get_node("MainState/Alive/Movement/Stopped").state_entered.connect(idle)
	state_machine.get_node("MainState/Alive/Convertion/Converting").state_entered.connect(convertion)
	wololo.lifeChanged.connect(on_pv_change)
	wololo.dead.connect(dead)
	
	
func convertion():
	muppet.visible = false
	key_frame.visible = true
	animator.play("wololo")

func idle():
	muppet.visible = true
	key_frame.visible = false
	animator.play("idle")
	
func walk():
	muppet.visible = true
	key_frame.visible = false
	animator.play("walk")

#func _process(delta):
	#if (Input.is_action_just_pressed("down")):
		#on_pv_change(50)
