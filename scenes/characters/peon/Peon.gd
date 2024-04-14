extends Character
class_name Peon
## Peon main class
##
## for all soldiers, handle attack mechanics

## Parameters 
# Define the current Peon type
enum EPeonType {SWORD, ARCHER, HORSE}
@export var peonType : EPeonType = EPeonType.SWORD

@onready var rig_epee = %RigEpee
@onready var rig_archer = %RigArcher
@onready var rig_cheval = $Graphsime/RigCheval


# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	
	# Show appropriate Rig for the Peon type
	match peonType:
		EPeonType.SWORD:
			rig_archer.hide()
			rig_epee.show()
		EPeonType.ARCHER:
			rig_archer.show()
			rig_epee.hide()
		EPeonType.HORSE:
			rig_archer.hide()
			rig_epee.hide()
			rig_cheval.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super(_delta)

