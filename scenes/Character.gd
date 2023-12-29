extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	Pagecounter.intialize_variables(0, get_tree().get_nodes_in_group("Pages").size())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
