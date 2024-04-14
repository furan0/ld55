extends Minigame

var tw : Tween
@export var n_iteration := 5

@onready var can := $game/Can
@onready var boot := $game/Boot
@onready var fx := $game/Speedtrait
var iter := 0.0


var busy = false

func action_just_press():
	if busy :
		return
	busy = true
	iter +=1.0
	fx.visible = true
	var tw = get_tree().create_tween()
	boot.scale = Vector2(1.2,0.8)
	tw.tween_property(boot,"position",Vector2(0.0,8*iter),0.05)
	tw.set_parallel(true).tween_property(boot,"scale",Vector2(0.7,1.3),0.05)
	await tw.finished
	fx.visible = false
	boot.get_node("Splash").visible = true
	can.scale = Vector2(1.0+iter/n_iteration*1.8,1.1-iter/n_iteration*0.8)
	await get_tree().physics_frame
	can.position.x = -3
	await get_tree().physics_frame
	can.position.x = 8
	boot.get_node("Splash").visible = false
	await get_tree().physics_frame
	can.position.x = -7
	busy = false
	var tw2 = get_tree().create_tween()
	tw2.tween_property(boot,"position",Vector2(0.0,-115),0.1)
	tw2.set_parallel(true).tween_property(boot,"scale",Vector2.ONE,0.1)
	if (iter<=n_iteration):
		tw.tween_property($Interface,"scale",Vector2.ONE*0.2,0.1)
		terminateMinigame(true)

# Called when the node enters the scene tree for the first time.

func runMinigame():
	$Interface.scale = Vector2(0.3,1.3)
	var tw = get_tree().create_tween()
	tw.tween_property($Interface,"scale",Vector2.ONE,0.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if(Input.is_action_just_pressed("down")):
		#action_just_press()
