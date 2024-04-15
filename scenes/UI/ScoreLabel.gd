extends Label
class_name ScoreLabel
## Display the score

@onready var game_manager = %GameManager

var score := 0
var isHighScore := false

@export var prefix:= "Score : "

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_show():
	if game_manager != null:
		score = game_manager.score
		isHighScore = score > game_manager.highscore
	displayScore()

func displayScore():
	text = prefix + str(score)
