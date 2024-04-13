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
@export var rushMargin := 10
@export var attackHitPoint := 25

var isAttacking := false
signal rushingToward(pos : Vector2)
signal startRush()
signal canAttack()
signal stopAttack()

# Called when the node enters the scene tree for the first time.
func _ready():
	# Start scanning at beginning 
	lookForTarget()

## Process called every frame when aware but not attacking
func processAware(_delta):
	# First, check target validity
	if !isTargetValid(target):
		# Invalidtarget -> remove it and look again
		lookForTarget()
		return
	
	var targetPos = target.global_position
	var currentPos = get_parent().global_position
	if abs(currentPos.distance_to(targetPos) ) <= rushDistance:
		startRush.emit()

## Process called every frame when attacking
func processAttacking(_delta):
	# First, check target validity
	if !isTargetValid(target):
		# Invalidtarget -> remove it and look again
		lookForTarget()
		return
	
	# Check if target in combat range
	var targetPos : Vector2  = target.global_position
	var currentPos : Vector2 = get_parent().global_position
	if abs(currentPos.distance_to(targetPos) ) <= attackRange:
		canAttack.emit()
	else:
		# Stop atacking
		stopAttack.emit()
		# Calculate new rush position
		var targetDir := (targetPos - currentPos).normalized()
		var desiredOffset := attackRange - rushMargin
		var desiredPos := targetPos - targetDir * desiredOffset
		rushingToward.emit(desiredPos)

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
		if !isTargetValid(body):
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

func isTargetValid(body : Node2D) -> bool:
	if body == null:
		return false
	if not body is Character:
		return false
	if body.faction == get_parent().faction:
		return false
	if body.is_dead:
		return false
	return true

func _draw():
	# Debug draw
	if !OS.has_feature("editor"):
		return
	
	draw_circle(Vector2.ZERO, rushDistance, Color.ORANGE)
	draw_circle(Vector2.ZERO, attackRange, Color.RED)

