extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")

func _on_how_to_play_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()




