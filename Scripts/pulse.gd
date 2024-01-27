extends ColorRect

@onready var conductor = $"../conductor"
@onready var p = $AnimationPlayer

var last_beat = 0
func _ready():
	conductor.beat.connect(_on_beat)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_beat(song: Song):
	if song.songPos > last_beat + song.spb:
		p.play("pulse")
		last_beat += song.spb
