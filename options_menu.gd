extends Control

func _on_back_pressed():
	
	get_tree().change_scene_to_file("res://menu.tscn")


func _on_back_mouse_entered():
	$click2.play()
	pass # Replace with function body.
