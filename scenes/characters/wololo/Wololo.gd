class_name Wololo
extends Character

## Wololo class
##
## Main player class. handle 'Wololo' and 'Ayoooo' stuffs i guess....

func _physics_process(_delta):
	super(_delta)

func _ready():
	super()
	state_machine.set_expression_property("blockConversion",false)
	state_machine.set_expression_property("blockSelection",false)
