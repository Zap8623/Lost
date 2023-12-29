extends Control

@onready var click_button = $click_button



func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Character.tscn")


func _on_option_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_quit_pressed():
	get_tree().quit()


func _on_play_mouse_entered():
	$click.play()
	pass # Replace with function body.


func _on_option_mouse_entered():
	$click.play()
	pass # Replace with function body.


func _on_quit_mouse_entered():
	$click.play()
	pass # Replace with function body.
