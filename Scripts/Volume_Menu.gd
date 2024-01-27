extends Control

var master_bus = AudioServer.get_bus_index("Master")
@export var Playing = false
var audio_stream2d: AudioStreamPlayer2D


func _ready():
	AudioServer.set_bus_volume_db(master_bus, 0)
	audio_stream2d = $AudioStreamPlayer2D
	audio_stream2d.stop()

func _on_h_slider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)

	if value >= 1 and not Playing:
		Playing = true
		audio_stream2d.play()
	elif value == 0:
		AudioServer.set_bus_mute(master_bus, true)
		Playing = false
		audio_stream2d.stop()
	else:
		AudioServer.set_bus_mute(master_bus, false)
		audio_stream2d.play()


func _on_back_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
