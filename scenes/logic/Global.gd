extends Node
## Game Main autoloaded class.
##
## This script handle all the global logics & initialization.
## It is autoloaded, and thus ALWAYS available for all scenes.
## The following are handled by this script:
##  - Global initialization, such as silentWolf configuration
##  - Scene handling and scene changes
##  - more TBD...


## ==== Scene Loading var
## Curent scene loaded
var currentScene : Node = null
## Is a scene loading in progress ?
var isANewSceneLoading : bool = false
## scene path currently loading
var sceneCurrentlyLoading : String = ""
## Signal emited during scene switch
signal sceneSwitchStarted
signal sceneSwitchCompleted

##=== Data storage
var save_data = {
	"score" : 0
}

## Global initialization
func _ready():
	# Retrieve currently loaded scene, ie the last one in the tree (after autoloads)
	var root = get_tree().root
	currentScene = root.get_child(root.get_child_count() - 1)
	
	# Configure random number generator
	randomize()


func _process(_delta : float):
	# If a scene is currently loading, update loading status
	if (isANewSceneLoading):
		var progress : Array[float] = [0.0]
		var status := ResourceLoader.load_threaded_get_status(sceneCurrentlyLoading, progress)
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				$LoadingUI.loadPercent = progress[0]
			ResourceLoader.THREAD_LOAD_FAILED | ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				# Error !! Signal it then abort scene switching
				push_error("Scene loading failed ! Wanted scene : " + sceneCurrentlyLoading)
				isANewSceneLoading = false
			ResourceLoader.THREAD_LOAD_LOADED:
				isANewSceneLoading = false
				$LoadingUI.loadPercent = 100.0
				call_deferred("_completeSceneLoading", sceneCurrentlyLoading)


# ============================
# | Scene Switching handling |
# ============================
## Call this function to change current scene with another one
##
## A loading display will be shown, the scene will be unloaded then the new scene will be 
## instanciated in its place
func goto_scene(path : String) -> void:
	# Refuse all scene switch if a switch is already ongoing
	if (isANewSceneLoading):
		push_warning("Scene " + path + "requested while already switching to " + sceneCurrentlyLoading)
		return
		
	# First, show the loading UI at 0%
	$LoadingUI.loadPercent = 0.0
	$LoadingUI.displayUI()
	
	# Then start the loading process
	ResourceLoader.load_threaded_request(path)
	sceneCurrentlyLoading = path
	isANewSceneLoading = true
	
	# Emit the scene switch signal
	sceneSwitchStarted.emit()
	print("Switching to scene " + path)
	
	# Then remove current scene next idle time
	currentScene.queue_free()


##This fucntion is called whenever the scene loading is completed
func _completeSceneLoading(path : String) -> void:
	# Load & instanciate the new scene.
	var s = ResourceLoader.load_threaded_get(path)
	currentScene = s.instantiate()
	
	# Add it to the active scene, as child of root.
	get_tree().root.add_child(currentScene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = currentScene
	
	# remove Loading UI & signal end of scene switching
	$LoadingUI.hideUI()
	sceneSwitchCompleted.emit()
	print("Scene switching completed")


## Reload current scene
func reloadCurrentScene():
	goto_scene(get_tree().current_scene.scene_file_path)

func pauseGame():
	get_tree().paused = true
	
func unpauseGame():
	get_tree().paused = false

func saveScore(score : int):
	if OS.is_userfs_persistent():
		# Create new ConfigFile object.
		var config = ConfigFile.new()
		config.set_value("Player1", "highScore", score)

		# Save it to a file (overwrite if already exists).
		config.save("user://scores.cfg")

func getHighScore() -> int:
	var config = ConfigFile.new()
	# Load data from a file.
	var err = config.load("user://scores.cfg")
	
	# If the file didn't load, ignore it.
	if err != OK:
		return 0
		
	return config.get_value("Player1", "highScore")
