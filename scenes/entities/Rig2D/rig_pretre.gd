extends Rig2D

@onready var state_machine = %StateMachine
@onready var wololo = $"../.."

@export var circleOffset := 1.0

var isConverting := false
var nextState  = null

func _ready():
	super._ready()
	idle()
	state_machine.get_node("MainState/Alive/Movement/Move").state_entered.connect(walk)
	state_machine.get_node("MainState/Alive/Movement/Stopped").state_entered.connect(idle)
	state_machine.get_node("MainState/Alive/Convertion/Converting").state_entered.connect(convertion)
	state_machine.get_node("MainState/Alive/Convertion/Converting").state_exited.connect(leaveConversion)
	state_machine.get_node("MainState/Alive/Selection/SelectingUnits").state_entered.connect($CircleDrawer.draw_my_circle)
	state_machine.get_node("MainState/Alive/Selection/SelectingUnits").state_exited.connect($CircleDrawer.undraw)

	wololo.lifeChanged.connect(on_pv_change)
	wololo.dead.connect(dead)
	$CircleDrawer.radius = $"../../SelectorHandler/CollisionShape".shape.radius + circleOffset
	
func convertion():
	isConverting = true
	muppet.visible = false
	key_frame.visible = true
	animator.play("wololo")

func leaveConversion():
	isConverting = false
	
	if nextState == null:
		nextState = idle
	nextState.call()
	nextState = null

func idle():
	if isConverting:
		nextState = idle
		return
		
	muppet.visible = true
	key_frame.visible = false
	animator.play("idle")
	
func walk():
	if isConverting:
		nextState = walk
		return
		
	muppet.visible = true
	key_frame.visible = false
	animator.play("walk")

#func _process(delta):
	#if (Input.is_action_just_pressed("down")):
		#on_pv_change(50)
