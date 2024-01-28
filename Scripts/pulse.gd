extends ColorRect

@onready var conductor = $"../conductor"
@onready var p = $AnimationPlayer


func _on_midi_player_midi_event(channel, event):
	p.play("pulse")
