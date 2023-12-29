extends Control




func _ready():
	Pagecounter.collected_collectables_update.connect(update_collectables_collected_display)
	Pagecounter.all_collectables_collected.connect(game_won)
	#character.connect("game_lose", self)

	$LabelWon.hide()
	$LabelLose.hide()
	update_collectables_collected_display()

func update_collectables_collected_display():
	$AmountCollectedLabel.text = str(Pagecounter.collected_collectables) + "/" + str(Pagecounter.total_collectables) + "collected"
func set_interaction_text_visible(text_visible : bool):
	$Label.visible = text_visible
	$TextureRect.visible = not text_visible

func set_interaction_lable_text(new_text : String):
	$Label.text = new_text
func game_won():
	$LabelWon.show()
#func gamelose():
	#$LabelLose.show()


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://scenes/Character.tscn")
