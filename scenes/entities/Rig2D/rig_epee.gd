extends Rig2D

#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.
#
#
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
	
