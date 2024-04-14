extends Resource
class_name SpawnLibrary
## A library of different entity group to spawn

@export var library : Array[SpawnGroup]

func getGroup(groupId : int) -> SpawnGroup:
	if library.is_empty():
		return null
	
	if groupId >= library.size():
		groupId = library.size() - 1
	return library[groupId]

func getRandomGroup() -> SpawnGroup:
	if library.is_empty():
		return null
		
	var rng := randi() % library.size()
	return library[rng]
