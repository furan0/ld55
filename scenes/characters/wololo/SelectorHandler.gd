extends Area2D

@onready var selection_marker = $SelectionMarker

signal selectionStarted()
signal selectionEnded()

var currentSelection = []

@export var SelectionPositionRadius := 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	selection_marker.hide()
	monitoring = false
	
	body_entered.connect(bodyDetected)

func _process(_delta):
	## Assign a selection position to each object selected 
	# Get circle increment
	var increment = 2 * PI / currentSelection.size()
	# Assign a point for each one
	var i := 0
	for selected in currentSelection:
		var posX = SelectionPositionRadius * cos(increment * i) + global_position.x
		var posY = SelectionPositionRadius * sin(increment * i) + global_position.y
		selected.setSelectionPosition(Vector2 (posX, posY))
		i += 1

func startSelection():
	selection_marker.show()
	monitoring = true
	selectionStarted.emit()

func releaseSelection():
	selection_marker.hide()
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

func _draw():
	# Debug draw
	if !OS.has_feature("editor"):
		return
	
	draw_circle(Vector2.ZERO, SelectionPositionRadius, Color.RED)
