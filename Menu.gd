extends Control

var music: MusicPlayer

func _on_play_pressed():
	print("1")
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_Options_pressed():
	print("2")
	get_tree().change_scene_to_file("res://Scenes/Options.tscn")

func _on_how_to_play_pressed():
	pass

func _on_exit_pressed():
	get_tree().quit()



func _on_ready():
	music = MusicPlayer.new()
	add_child(music)
	
	# loop the title theme track
	var s = music.load_song("res://Assets/audio/audio/menu/GGJ24_Title_Screen_Track.wav", "",  0, 0)
	s.songStartPos = 0.113
	s.create_fx(SongFX.new(s, SongFX.EFFECT.LOOP, s.songStartPos, 0))
	music.play_next()
