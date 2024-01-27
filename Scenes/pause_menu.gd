extends Control

var pause_menu: Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu = $"."
	pause_menu.visible = false

func _on_menu_pressed():
	print("XD")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	
func toggle_pause():
	if not pause_menu.is_visible():
		get_tree().paused = true
		pause_menu.visible = true
	else:
		get_tree().paused = false
		pause_menu.visible = false

func _on_options_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")

func _on_exit_pressed():
	print("bruh")
	get_tree().quit()


func _on_restart_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.keycode == KEY_ESCAPE and key_event.pressed:
			toggle_pause()




