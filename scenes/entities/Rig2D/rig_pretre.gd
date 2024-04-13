extends Rig2D

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
