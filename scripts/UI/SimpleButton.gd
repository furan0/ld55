extends Button

@export var sceneToLoad : String = ""
@export var reloadCurrentScene := false
@export var goToNextLevel := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_click)

func _on_click():
	if !sceneToLoad.is_empty():
		Global.goto_scene(sceneToLoad)
	elif reloadCurrentScene:
		Global.reloadCurrentScene()
	elif goToNextLevel:
		var manager = %GameManager
		if manager != null:
			Global.goto_scene(manager.nextLevelPath)
		else:
			printerr("Game manager not found for next level load")
