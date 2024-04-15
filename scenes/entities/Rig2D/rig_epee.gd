extends Rig2D

@onready var state_machine = %StateMachine
@onready var peon = $"../.."

## Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	state_machine.get_node("MainState/Alive/Movement/Move").state_entered.connect(walk)
	state_machine.get_node("MainState/Alive/Movement/Stopped").state_entered.connect(idle)
	state_machine.get_node("MainState/Alive/Status/Attacking/AttackAction/PreAttack").state_entered.connect(preattaque)
	state_machine.get_node("MainState/Alive/Status/Attacking/AttackAction/Attack").state_entered.connect(attaque)
	state_machine.get_node("MainState/Alive/Status/Attacking/AttackAction").state_exited.connect(attackExited)
	state_machine.get_node("MainState/Alive/Status/Selected").state_entered.connect(on_select)
	state_machine.get_node("MainState/Alive/Status/Selected").state_exited.connect(deslect)
	state_machine.get_node("MainState/Alive/Status/Idle/Aware").state_entered.connect(play_interogation)
	
	peon.lifeChanged.connect(on_pv_change)
	peon.dead.connect(dead)

##### Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if (Input.is_action_just_pressed("down")):
		#dead()

func on_select():
	play_exclamation()
	$Circle.visible = true
func deslect():
	$Circle.visible = false
func walk():
	animator.play("walk")
func idle():
	animator.play("idle")
func attaque():
	$attaque.play_sound()
	animator.play("attaque")
func preattaque():
	animator.play("preattaque")
	
func on_pv_change(new_pv):
	super.on_pv_change(new_pv)
	$hurt.play_sound()
	
func dead():
	animator.play("dead")
	super.dead()

func attackExited():
	if peon.velocity != Vector2.ZERO:
		walk()
	else:
		idle()
