extends Node2D

@onready var label = $PanelDialog/MarginContainer/RichTextLabel
@export var defaultText := ""
@export var displayTimePerLetter := 0.5

var textTweener : Tween

signal textDisplayFinished()
var isTextDisplayFinished := true

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible_ratio = 0.0
	hide()
	#display()

func display():
	displayText(defaultText)

func displayText(text : String):
	label.visible_ratio = 0.0
	label.text = text
	show()
	tweenText()

func tweenText():
	isTextDisplayFinished = false
	var totalDisplayTime : float = displayTimePerLetter * label.text.length()
	
	# Generate new tweener
	if textTweener != null:
		textTweener.kill()
	textTweener = get_tree().create_tween()
	#textTweener.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Start tweener
	textTweener.tween_property(label, "visible_ratio", 1.0, totalDisplayTime)
	textTweener.finished.connect(_text_display_is_finished)

func forceFullDisplayOrHide():
	# Text still displaying -> force full display
	if !isTextDisplayFinished:
		if textTweener != null:
			textTweener.kill()
			textTweener = null
		label.visible_ratio = 1.0
		_text_display_is_finished()
	
	# Text fully displayed -> hide panel
	else:
		hide()
	

func _text_display_is_finished():
	isTextDisplayFinished = true
	textDisplayFinished.emit()
