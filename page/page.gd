extends Interactable


func _init():
	interaction_prompt_text = "Press 'E' to collect"
	
func interacted_with():
	print("collected: " + self.name)
	Pagecounter.collected_collectables += 1
	#hide()
	#$CollisionShape3D.disabled = true
	#await $"Coin collect sound".finished
	queue_free()
