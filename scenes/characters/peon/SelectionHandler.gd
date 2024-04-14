extends Node2D
class_name SelectionHandler
## handle selection (duuh...)
##
## This is for class that are selectable, not class that select thingies

## parameters
#can this object be selected one day ?
@export var selectable := true
# and right now, is it selectable ?
@onready var canBeSelected := selectable
# is it currently selected ?
var isSelected = false
var selector : Node = null
signal selected()
signal released()
signal requestSelecPos(target : Vector2)

## Set if an object scan be selected right now or not.
## the Selectable parameter still override the selectable if set to false
func setSelectionStatus(isSelectionEnabled : bool):
	if isSelectionEnabled:
		canBeSelected = selectable
	else:
		canBeSelected = false

## Select a node. the selector must pass itself into the parameter
func select(selector_ : Node):
	selector = selector_
	isSelected = true
	selected.emit()
	
	# You can't be selected multiple times 
	setSelectionStatus(false)
	
	# Log selection
	#print(str(self) + " is selected")

##Release an unit from selection
func release():
	if isSelected:
		isSelected = false
		released.emit()
		
		# Re-enable selection
		setSelectionStatus(true)
		
		# Log selection
		#print(str(self) + " is released")

##Assign a position to go to
func setSelectionPosition(targetPos : Vector2):
	requestSelecPos.emit(targetPos)
