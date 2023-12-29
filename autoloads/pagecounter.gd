extends Node

signal collected_collectables_update
signal all_collectables_collected

var total_collectables = -1

var collected_collectables = 0 :
	set(value):
		collected_collectables = value
		emit_signal("collected_collectables_update")
		
		if value >= total_collectables:
			emit_signal("all_collectables_collected")
func intialize_variables(initial : int, total : int):
	total_collectables = total
	collected_collectables = initial
