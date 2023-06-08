extends Node3D

func _ready():
	var trees = $Trees.get_children()
	
	for tree in trees:
		tree.get_node("Animations").play("default")
