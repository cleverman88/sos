extends Node
class_name Conductor

signal beat

var playing = [] # the current songs we are playing

func _ready():
	start_song("res://Assets/audio/audio/GGJ24_Track_2_130_BPM_C_Minor.wav", "", 0)
func start_song(song_path: String, data_path, fade_in_override = -1):
	var s = Song.new(song_path, data_path, fade_in_override)
	s.song_beat.connect(_on_song_beat)
	add_child(s.player)
	s.play()
	playing.append(s)
	
func _process(delta):
	for song in playing:
		song._process(delta)

func _on_song_beat(barsAndBeat: Vector2):
	# TODO: check progress of song, queue next song / adjust BPMs
	print(barsAndBeat)
	beat.emit(barsAndBeat)

func _on_song_end(source: String):
	for i in range(playing.size()):
		if playing[i].source == source and not playing[i].playing:
			remove_child(playing[i].player)
			playing.remove_at(i)
			break
