extends Rig2D

#
## Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	$"../../StateMachine/MainState/Alive/Movement/Move".state_entered.connect(walk)
	$"../../StateMachine/MainState/Alive/Movement/Stopped".state_entered.connect(idle)
	$"../../StateMachine/MainState/Alive/Status/Attacking/AttackAction/PreAttack".state_entered.connect(preattaque)
	$"../../StateMachine/MainState/Alive/Status/Attacking/AttackAction/Attack".state_entered.connect(attaque)
##### Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if (Input.is_action_just_pressed("down")):
		#dead()


func walk():
	animator.play("walk")
func idle():
	animator.play("idle")
func attaque():
	animator.play("attaque")
func preattaque():
	animator.play("preattaque")
	
func dead():
	animator.play("dead")
	super.dead()
	
