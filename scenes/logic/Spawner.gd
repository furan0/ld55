extends Node2D
class_name Spawner

var spawnPoints := []
signal newCharacterCreated(peon : Character)

# Called when the node enters the scene tree for the first time.
func _ready():
	spawnPoints = get_children()

## Spawn a given group
func spawnGroup(group : SpawnGroup):
	var spawnindex = 0
	for entity in group.group:
		if spawnindex >= spawnPoints.size():
			break
		
		print("overlapse : " + str(spawnPoints[spawnindex].get_overlapping_bodies().size()))
		if spawnPoints[spawnindex].has_overlapping_bodies():
			# Spawn point already full
			print("Spawn full")
			continue 
		
		var node = entity.instantiate()
		self.get_parent().add_child(node)
		node.global_position = spawnPoints[spawnindex].global_position
		newCharacterCreated.emit(node)
		print("Entity spawned : " + str(node) + " at " + str(global_position) + " from " + str(self))
		
		spawnindex += 1
