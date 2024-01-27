extends Node
class_name Conductor

signal beat # (bpm: float, [bars, beat]: Vector2, remaining_time: float)

var playing = [] # the current songs we are playing
var queue = []   # the songs we want to play next

const songs = [
	"res://Assets/audio/audio/GGJ24_Track_1_Demo_110_BPM_C_Minor.wav",
	"res://Assets/audio/audio/Basic_Ah_Beat_120BPM.wav",
	"res://Assets/audio/audio/gamer_tunes.wav"
]

var rng = RandomNumberGenerator.new()

func _ready():
	load_song(songs[1], "", 0, 0)
	play_next()
	
func load_song(song_path: String, data_path, fade_in_override = -1, fade_out_override = -1):
	var s = Song.new(song_path, data_path, fade_in_override, fade_out_override)
	s.song_beat.connect(_on_song_beat)
	s.song_stop.connect(_on_song_end)
	add_child(s.player)
	queue.append(s)
	
func play_next():
	var s = queue.pop_front()
	s.play()
	playing.append(s) 
	
func _process(delta):
	for song in playing:
		song._process(delta)
		
	# TODO: sync the BPM during track changeover

func _on_song_beat(bpm: float, barsAndBeat: Vector2, remaining_time: float):
	print("bpm: ", bpm, ", bar: ", barsAndBeat[0], ", beat: ", barsAndBeat[1], ", remaining: ", remaining_time)
	beat.emit(bpm, barsAndBeat, remaining_time)
	if playing.size() < 2 and remaining_time < 20:
		if queue.size() == 0:
			# TODO: queue next song better
			load_song(songs[rng.randi_range(0, songs.size() - 1)], "")
		elif remaining_time <= queue[0].fadeInDuration:
			# play the new song we have queued
			play_next()
			playing[0].song_beat.disconnect(_on_song_beat)

func _on_song_end(source: String):
	for i in range(playing.size()):
		if playing[i].source == source and not playing[i].started:
			remove_child(playing[i].player)
			playing.remove_at(i)
			break
