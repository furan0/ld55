extends Node2D
class_name AttackHandler
##Handle Peon attack behavior
##
## handle attack logic, target finding, hit dispensing etc

@export_group("Target Finding settings")
var target : Character = null
@export var TargetWeigth = {
	Peon.EPeonType.SWORD: 1.0,
	Peon.EPeonType.ARCHER: 0.5,
	Peon.EPeonType.HORSE: 2.0,
	"wololo": 2.0
}
@onready var area_aware = $AreaAware
@onready var aware_timer = $AwareTimer
@export var isLookingForTarget := true

signal targetLost()
signal newTargetFound()


@export_group("Attack settings")
@export var rushDistance := 100
@export var attackRange := 75
@export var attackHitPoint := 25

var isAttacking := false
signal startRush(pos : Vector2)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start scanning at beginning 
	lookForTarget()


func processAware(_delta):
	if target == null:
		printerr("Aware without a valid target...")
		targetLost.emit()
		return;
	
	var targetPos = target.global_position
	var currentPos = get_parent().global_position
	if abs(currentPos.distance_to(targetPos) ) <= rushDistance:
		startRush.emit(targetPos)
		

func lookForTarget():
	if !isLookingForTarget:
		return
		
	var bodies : Array[Node2D] = area_aware.get_overlapping_bodies()
	if bodies.is_empty():
		if target != null:
			# We lost curent target...
			target = null
			targetLost.emit()
			print("target lost")
		aware_timer.start()
		return
	
	var currentBestTarget := target
	var currentBestDist : float = 999999999999.0
	for body in bodies:
		#check if same faction or not character
		if not body is Character || body.faction == get_parent().faction:
			continue
			
		# check distance
		var distance = body.global_position.distance_squared_to(get_parent().global_position)
		# Add target ponderation
		# For Wololo
		if body is Wololo:
			distance *= 1.0 / TargetWeigth["wololo"]
		elif body is Peon:
			distance *= 1.0 / TargetWeigth[body.peonType]
		else:
			## Uuuh that shouldn't happend
			printerr("Target found which are neither Peon nor Wololo...")
		
		# If better distance, select that target
		if distance <= currentBestDist:
			currentBestDist = distance
			currentBestTarget = body as Character
	
	# Check if we acquired a target in the end*
	if currentBestDist > 999999999990.0 || currentBestTarget == null:
		if target != null:
			# We lost curent target...
			target = null
			targetLost.emit()
			print("target lost")
	elif target != currentBestTarget:
		target = currentBestTarget
		newTargetFound.emit()
		print("new target found : " + str(target) + " at distance : " + str(currentBestDist))
	# Relaunch itself
	aware_timer.start()

func enableTargetLooking(enabled : bool):
	if enabled && !isLookingForTarget:
		# Start looking
		isLookingForTarget = true
		lookForTarget()
	isLookingForTarget = enabled

func _draw():
	# Debug draw
	if !OS.has_feature("editor"):
		return
	
	draw_circle(Vector2.ZERO, rushDistance, Color.ORANGE)
	draw_circle(Vector2.ZERO, attackRange, Color.RED)
