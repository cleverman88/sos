extends Button



func _on_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func _on_volume_pressed():
	get_tree().change_scene_to_file("res://Scenes/Volume_Menu.tscn")
