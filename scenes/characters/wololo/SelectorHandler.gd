extends Area2D

signal selectionStarted()
signal selectionEnded()

var currentSelection = []
var startingAngle := PI + 1.41 * 0.2 # Je sors ça de mon cul.

@export var SelectionPositionRadius := 150.0
@export var showPosHelper := false

# Called when the node enters the scene tree for the first time.
func _ready():
	monitoring = false
	
	body_entered.connect(bodyDetected)

func _process(_delta):
	## Assign a selection position to each object selected 
	# Get circle increment
	var increment = 2 * PI / currentSelection.size()
	# Assign a point for each one
	var i := 0
	for selected in currentSelection:
		print("Angle target " + str(i) + " : " + str(global_position.angle_to_point(selected.global_position)))
		var posX = SelectionPositionRadius * cos(startingAngle + increment * i) + global_position.x
		var posY = SelectionPositionRadius * sin(startingAngle + increment * i) + global_position.y
		selected.setSelectionPosition(Vector2 (posX, posY))
		i += 1

func sort_selection_clockwise(a, b):
	var angleA = global_position.angle_to_point(a.global_position)
	var angleB = global_position.angle_to_point(b.global_position)
	return  angleA < angleB

func startSelection():
	monitoring = true
	selectionStarted.emit()

func releaseSelection():
	monitoring = false
	selectionEnded.emit()
	
	# Release all selected nodes
	for selected in currentSelection:
		selected.release();
	currentSelection.clear()

func bodyDetected(body : Node2D):
	var handler := body.get_node_or_null("SelectionHandler") as SelectionHandler
	if handler == null || !handler.canBeSelected:
		#Not selectable, return
		return
	
	## Check faction
	if body is Character && get_parent() is Character:
		if body.faction != get_parent().faction:
			# Not the same faction (yet... ;) )
			return
	
	## Everything is OK, add to selection
	addToSelection(handler)

func addToSelection(selection : SelectionHandler):
	selection.select(self)
	currentSelection.append(selection)
	
	# Set starting anle or sort selection
	if (currentSelection.size() == 1):
		# We are the first one -> set starting angle
		pass
		# startingAngle = global_position.angle_to_point(selection.global_position)
	else:
		# We are not the first one -> sort the selection array by angle
		currentSelection.sort_custom(sort_selection_clockwise)

func _draw():
	# Debug draw
	if !OS.has_feature("editor") || !showPosHelper:
		return
	
	draw_circle(Vector2.ZERO, SelectionPositionRadius, Color.RED)
