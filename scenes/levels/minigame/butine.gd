extends Minigame
@export var tolerance = 20

var busy = false

func action_just_press():
	if busy:
		return
	busy = true
	get_tree().create_tween().tween_property($game/Panel/Abeille,"position",$game/Panel/Abeille.position,randf_range(1.0,1.5))

	if abs($game/Panel/Fleure.position.x - $game/Panel/Abeille.position.x)<tolerance:
		print("ok")
		$game/Panel/Abeille.modulate = Color.BISQUE
		$game/Panel/Abeille.scale = Vector2.ONE * 1.2
		get_tree().create_tween().tween_property($game/Panel/Fleure,"scale",Vector2.ONE*1.4,0.1)
		terminateMinigame(true)
	else:
		print("ko")
		$game/Panel/Abeille.modulate = Color.DIM_GRAY
		$game/Panel/Fleure.modulate = Color.DIM_GRAY
		get_tree().create_tween().tween_property($game/Panel/Fleure,"scale",Vector2.ONE*0.4,0.1)
		terminateMinigame(false)
func run_bzz():
	$game/Panel/Abeille.position.x = -165
	get_tree().create_tween().tween_property($game/Panel/Abeille,"position",Vector2(175,0),randf_range(1.0,1.5)).finished.connect(_endgame)

func _endgame():
	if busy:
		return
	busy = true
	print("ko")
	terminateMinigame(false)
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	runMinigame()

func runMinigame():
	busy = false
	$game/Panel.scale = Vector2(0.3,1.3)
	get_tree().create_tween().tween_property($game/Panel,"scale",Vector2.ONE,0.1)
	$game/Panel/Fleure.position.x = randf_range(40,155)
	get_tree().create_timer(0.3).timeout.connect(run_bzz)
	
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#if( Input.is_action_just_pressed("left")):
		#runMinigame()
	#if( Input.is_action_just_pressed("down")):
		#action_just_press()
