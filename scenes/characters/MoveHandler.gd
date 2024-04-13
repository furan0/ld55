extends Node2D
class_name MoveHandler
## generic class for handlign all movement request to the Character controller
##
## it can be either controlled by position or direction


# params
@export_group("Move settings")
@export var MAX_SPEED := 300.0
@export var acc_start := 0.4
@export var acc_end := 0.4
var current_speed := MAX_SPEED
@export var direction := Vector2.ZERO
var targetDirection := Vector2.ZERO
var useNaveMeshAgent := false
@export var canMove := true
var calculatedVelocity := Vector2.ZERO

# Nav mesh agent
@export_group("NavMesh Agent settings")
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@export var pathDesiredDistance := 4.0
@export var targetDesiredDistance := 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Make sure to not await during _ready.
	call_deferred("actorSetup")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if canMove:
		# Check if target Direction or position is used 
		if useNaveMeshAgent:
			#NavMesh control
			if navigation_agent.is_navigation_finished():
				direction = Vector2.ZERO
			else:
				var current_agent_position: Vector2 = global_position
				var next_path_position: Vector2 = navigation_agent.get_next_path_position()
				direction = current_agent_position.direction_to(next_path_position)
		else: 
			# Direct direction control
			if targetDirection != Vector2.ZERO:
				direction = lerp(direction, targetDirection, acc_start)  # Un peu d'inertie	
			else:
				direction = Vector2.ZERO
		
		# lerp depending on starting or stopoing move
		var previousVelocity := calculatedVelocity
		calculatedVelocity = direction.normalized() * current_speed
		if previousVelocity.length_squared() > calculatedVelocity.length_squared():
			# We are stopping 
			calculatedVelocity = lerp(previousVelocity, calculatedVelocity, acc_end)
		else :
			# We are starting to move
			calculatedVelocity = lerp(previousVelocity, calculatedVelocity, acc_start)
	else:
		# Can't move => no velocity*
		calculatedVelocity = Vector2.ZERO

##Setup navmesh agent params
func actorSetup():
	navigation_agent.path_desired_distance = pathDesiredDistance
	navigation_agent.target_desired_distance = targetDesiredDistance
	
	await get_tree().physics_frame
	

func moveToward(target_dir : Vector2):
	targetDirection = target_dir
	# cancel target position
	useNaveMeshAgent = false

func moveTo(target_pos : Vector2):
	navigation_agent.target_position = target_pos
	useNaveMeshAgent = true
	# cancel target direction
	targetDirection = Vector2.ZERO
