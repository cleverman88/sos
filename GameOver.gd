extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func set_score(value):
	$Panel/Score.text = "Score: " + str(value)
	







