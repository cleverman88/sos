extends Control

func _on_play_pressed():
	print("1")
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_Options_pressed():
	print("2")
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_how_to_play_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()





