extends Control

var music: MusicPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://Scenes/options_menu.tscn")

func _on_how_to_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/how_to_play.tscn")

func _on_exit_pressed():
	get_tree().quit()



func _on_ready():
	music = MusicPlayer.new()
	add_child(music)
	
	# loop the title theme track
	var s = music.load_song("res://Assets/tracks/menu/GGJ24_Title_Screen_Track.wav")
	s.create_fx(SongFX.new(s, SongFX.EFFECT.LOOP, s.songStartPos, 0))
	music.play_next()
