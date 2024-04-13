extends Node2D
class_name LookAt
## This class look at things

# Set to true to accept looking at things
var canUpdateItsRotation : bool = true
## max Rotation speed. Set to 0 for no limit
@export var maxAngularVelocity : float = 0

@onready var wantedRotation : float = rotation

## Set if this object can look ath things or not
func canLookAtThings(status : bool):
	canUpdateItsRotation = status

## Set the rotation, if we can...
func setRotation(value: float):
	if !canUpdateItsRotation:
		return
	wantedRotation = value;

func _process(_delta):
	if !canUpdateItsRotation:
		return
	
	if !is_equal_approx(maxAngularVelocity, 0.0):
		if abs(wantedRotation) >= maxAngularVelocity:
			rotation += (maxAngularVelocity * sign(wantedRotation))
		else:
			rotation += wantedRotation
	else:
		rotation = rotation + wantedRotation


##Set rotation with a given vector
func setRotationVect(vector : Vector2):
#	print(vector)
	var direction := Vector2(cos(rotation),sin(rotation))
	
	setRotation(direction.angle_to(vector))

## Rotate to the given value with a maximal angular speed
func setRotationSlowed(value : float, angularSpeed : float):
	if !canUpdateItsRotation:
		return
	
	var rotationToDo := value - rotation
	
	
	
	if abs(rotationToDo) >= angularSpeed:
		rotation += (angularSpeed * sign(rotationToDo))
	else:
		rotation += rotationToDo


##Set max rotation speed. et 0 for unlimited
func setMaxRotationSpeed(speed : float):
	maxAngularVelocity = speed
