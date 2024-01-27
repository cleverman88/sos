extends Node
class_name MusicPlayer

signal beat # (song: Song)


var playing = [] # the current songs we are playing
var queue = []   # the songs we want to play next


func _ready():
	pass

func load_song(song_path: String, data_path, fade_in_override = -1, fade_out_override = -1) -> Song:
	var s = Song.new(song_path, data_path, fade_in_override, fade_out_override)
	s.song_beat.connect(_on_song_beat)
	s.song_stop.connect(_on_song_stop, CONNECT_ONE_SHOT)
	add_child(s.player)
	queue.append(s)
	return s
	
func play_next() -> Song:
	var s = queue.pop_front()
	s.play()
	playing.append(s) 
	return s
	
func _process(delta):
	for song in playing:
		song._process(delta)

func _on_song_beat(_song: Song):
	pass

func _on_song_stop(song: Song):
	remove_child(song.player)
	playing.erase(song)
