extends Node

func fade_stream(stream:AudioStreamPlayer,volume=0,temps=1.0):
	get_tree().create_tween().tween_property(stream,"volume_db",volume,0.2)
	

func end_calme():
	pass
	
func end_intense():
	pass


func fade_to_calme():
	if $musiquetendue.playing:
		fade_stream($musiquetendue,-80.0)
	fade_stream($musiquecalme,0.0)
	$musiquecalme.play(0)

func fade_to_intense():
	if $musiquecalme.playing:
		fade_stream($musiquecalme,-80.0)
	fade_stream($musiquetendue,0.0)
	$musiquetendue.play(0)

func fade_to_lose(character=null):
	if $"..".currentGameMode == GameManager.EGameMode.MULTI:
		return
	fade_stream($musiquetendue,-80.0,0.2)
	fade_stream($musiquecalme,-80.0,0.2)

	$musicdefete.play()

func fade_to_victoire(character=null):
	fade_stream($musiquetendue,-80.0,0.2)
	fade_stream($musiquecalme,-80.0,0.2)
	
	$musiquevictoire.play()

# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().victory.connect(fade_to_victoire)
	get_tree().create_timer(1.5).timeout.connect(fade_to_calme)
	$musiquetendue.finished.connect(fade_to_calme)
	$musiquecalme.finished.connect(fade_to_calme)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
