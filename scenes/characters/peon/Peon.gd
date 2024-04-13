extends Character
class_name Peon
## Peon main class
##
## for all soldiers, handle attack mechanics

## Parameters 
# Define the current Peon type
enum EPeonType {SWORD, ARCHER, HORSE}
@export var peonType : EPeonType = EPeonType.SWORD

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

