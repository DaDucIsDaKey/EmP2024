extends Button
var k=preload("res://src/test.tscn") #Preload the game

func _on_self_pressed() -> void: #When pressed,
	get_tree().change_scene_to_packed(k) #Start the game.
