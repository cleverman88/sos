extends Control

var music: MusicPlayer

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_game.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")


func set_score(value):
	$Panel/Score.text = "Score: " + str(value)
	
func _on_ready():
	music = MusicPlayer.new()
	add_child(music)
	
	# loop the title theme track
	var s = music.load_song("res://Assets/gameover.wav")
	s.set_playback_volume(-20)
	s.create_fx(SongFX.new(s, SongFX.EFFECT.LOOP, s.songStartPos, 5))
	music.play_next()







