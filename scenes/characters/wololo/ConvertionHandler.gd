extends Area2D
class_name ConversionHandler
##Handle convertion of units

@onready var timer = $Timer
@onready var target_indicator = $TargetIndicator
@onready var state_machine = %StateMachine
@onready var wololo = $".."

var target : Peon = null
@export var canConvert := true

@export var convertionMinigames = {
	Peon.EPeonType.SWORD: preload("res://scenes/levels/minigame/TestMinigame.tscn"),
	Peon.EPeonType.ARCHER: preload("res://scenes/levels/minigame/TestMinigame.tscn"),
	Peon.EPeonType.HORSE: preload("res://scenes/levels/minigame/TestMinigame.tscn")
	}
signal minigameFailed()
signal minigameSuccesful()

# Called when the node enters the scene tree for the first time.
func _ready():
	state_machine.set_expression_property("hasTarget", false)
	target_indicator.hide()
	target_indicator.modulateColor(Character.getFactionColor(wololo.faction))
	timer.timeout.connect(detectTargets)

func updateTarget(newTarget : Node2D):
	if newTarget == null:
		target = null
		target_indicator.hide()
		state_machine.set_expression_property("hasTarget", false)
	else:
		print("new target : " + str(target))
		target = newTarget
		target_indicator.attachTarget(newTarget)
		target_indicator.show()
		state_machine.set_expression_property("hasTarget", true)

func detectTargets():
	if !canConvert:
		return;
	
	if target != null && !isTargetValid(target):
		updateTarget(null);
		
	var bodies : Array[Node2D] = get_overlapping_bodies()
	if bodies.is_empty():
		if target != null:
			# We lost curent target...
			updateTarget(null)
		timer.start()
		return
	
	var currentBestTarget : Node2D = null
	var currentBestDist : float = 999999999999.0
	for body in bodies:
		#check if same faction or not character
		if !isTargetValid(body):
			continue
		# check distance
		var distance = body.global_position.distance_squared_to(get_parent().global_position)
		
		# If better distance, select that target
		if distance <= currentBestDist:
			currentBestDist = distance
			currentBestTarget = body
	
	# Check if we acquired a target in the end*
	if currentBestDist > 999999999990.0 || currentBestTarget == null:
		if target != null:
			# We lost curent target...
			updateTarget(null)
	elif target != currentBestTarget:
		updateTarget(currentBestTarget)
		
	# Relaunch itself
	timer.start()

func convertTarget():
	if !isTargetValid(target):
		print("Target is now invalid")
		return
		
	target.setFaction(wololo.faction)
	updateTarget(null)

func startMinigameOnCurrentTarget():
	if !isTargetValid(target):
		return
	
	print("Minigame for peon of type " + str(target.peonType))
	var minigame : PackedScene = convertionMinigames[target.peonType]
	if minigame == null:
		printerr("Minigame not found for " + str(target.peonType))
		minigameFailed.emit()
		return;
	
	var scene := minigame.instantiate()
	scene.global_position = global_position
	add_child(scene)
	var game = scene as Minigame
	if game == null:
		printerr("Minigame scene is not of minigame type")
		minigameFailed.emit()
		return;
	game.setCallback(minigameCallback)
	game.runMinigame()

func minigameCallback(status : bool):
	print("Minigame finished : " + str(status))
	if status:
		minigameSuccesful.emit()
	else:
		minigameFailed.emit()

func isTargetValid(node : Node2D) -> bool :
	if node == null:
		return false
	if not node is Peon:
		return false
	if node.is_dead:
		return false
	if node.faction == wololo.faction:
		return false
		
	return true;

func stopAllConvertion():
	canConvert = false;
	updateTarget(null)

func disableNewConvertion():
	canConvert = false;

func enableNewConvertion():
	canConvert = true;
	detectTargets();
