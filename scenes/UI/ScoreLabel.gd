extends RichTextLabel
class_name ScoreLabel
## Display the score

@onready var game_manager = %GameManager

var score := 0
var isHighScore := false

@export var prefix:= "[center][b]Score : "
@export var prefixHighScore:= "[center][b][color=ff0000]New High Score : "
@export var highScoreScaleMax := 0.1
@export var highScoreTweenDuration := 0.2

func _ready():
	if game_manager == null:
		game_manager = get_tree().get_first_node_in_group("manager")

func updateDisplay():
	if game_manager != null:
		score = game_manager.score
		isHighScore = score > game_manager.highScore
	else:
		print("No manager...")
		isHighScore = true
	displayScore()
	

func displayScore():
	if isHighScore:
		text = prefixHighScore + str(score)
		doTween()
	else:
		text = prefix + str(score)
	
func doTween():
	var initialScale : Vector2 = get_parent().scale
	var wantedScale := initialScale + highScoreScaleMax * Vector2.ONE
	var tw := get_tree().create_tween()
	tw.tween_property(get_parent(),"scale",wantedScale,highScoreTweenDuration).set_ease(Tween.EASE_IN)
	tw.tween_property(get_parent(),"scale",initialScale,highScoreTweenDuration).set_ease(Tween.EASE_OUT)
	
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.set_loops()
