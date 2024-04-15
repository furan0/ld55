extends Area2D
class_name TextTrigger

@export_multiline var texts : Array[String] = []
var currentIndex = 0
@export var isOneShot = true

var isDisplaying := false

signal triggerFinished()
signal triggerStarted()

# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)

func displayText(player : Node2D):
	isDisplaying = true
	var box = player.get_node("DialogBox")
	if box == null:
		print("Dialog Box not found")
		return
	
	displayNextText(box)
	box.textDisplayIsClosing.connect(displayNextText.bind(box))
	
func _on_body_entered(body : Node2D):
	if isDisplaying:
		return
	if body is Wololo && body.faction == Character.EFaction.BLUE:
		triggerStarted.emit()
		displayText(body)

func displayNextText(dialogBox : Node2D):
	if currentIndex >= texts.size():
		if isOneShot:
			queue_free()
		else:
			isDisplaying = false
			currentIndex = 0
		triggerFinished.emit()
		return
	
	dialogBox.displayText(texts[currentIndex])
	currentIndex += 1
