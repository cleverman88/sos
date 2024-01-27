extends Control

var pause_menu: Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	pause_menu = $"."
	pause_menu.visible = false

func _on_back_pressed():
	print("XD")
	get_tree().change_scene("res://Scenes/menu.tscn")

func toggle_pause():
	if not pause_menu.is_visible():
		get_tree().paused = true
		pause_menu.visible = true
	else:
		get_tree().paused = false
		pause_menu.visible = false

func _on_options_pressed():
	get_tree().change_scene("res://Scenes/options_menu.tscn")

func _on_exit_pressed():
	print("bruh")
	get_tree().quit()


func _on_resume_button_pressed():
	toggle_pause()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event = event as InputEventKey
		if key_event.keycode == KEY_ESCAPE and key_event.pressed:
			toggle_pause()
