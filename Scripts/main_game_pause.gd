extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false 

@onready var notes = preload("res://Scenes/note_new.tscn")

var delta_sum_ := 0.0

var left := []
var meowSkip = 1
var beatSkip = 1
var last_note

@onready var stuff := {
	144: {
		"key": "ui_left",
		"node": get_node("note/space"),
		"queue": [],
		"diff": -100,
		"meow" : true
	},
	128: {
		"key": "ui_right",
		"node": get_node("note/left"),
		"queue": [],
		"diff": 100,
		"meow" : false
	},
}


func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
func _process(delta):
	#if Input.is_action_just_pressed("pause"):
		#pauseMenu()
	delta_sum_ += delta
	for s in stuff.values():
		if Input.is_action_just_pressed(s.key):
			if not (len(s.queue) == 0):
				if s.queue.front().test_hit(delta_sum_):
					s.queue.pop_front().hit(s.node.global_position)
					hit()
				else:
					missed()
			else:
				missed()
				
		if not (len(s.queue) == 0):
			if s.queue.front().test_miss(delta_sum_):
				s.queue.pop_front().miss()
				missed()

	for s in stuff.values():
		s.node.pressed = Input.is_action_pressed(s.key)
	
	if delta_sum_ >= 1.0 and not $music.playing:
		$music.play()

func pauseMenu():
	if paused:
		pause_menu.hide()
	else:
		pause_menu.show()
	paused = !paused
	


func _on_midi_player_midi_event(channel, event):
	var s = stuff.get(event.type)
	print( event.type,meowSkip,beatSkip)
	if s:
		if event.type == 144 and (meowSkip % 2 == 0):
			meowSkip += 1
			var i = notes.instantiate()
			add_child(i)
			i.expected_time     = delta_sum_ + 1.0
			i.global_rotation   = s.node.global_rotation
			i.global_position.y = 125
			i.global_position.x = s.node.global_position.x + s.diff 
			last_note = s
			s.queue.push_back(i)
		else:
			meowSkip += 1
			
		if event.type == 128 and (beatSkip % 4 == 0):
			beatSkip += 1
			var i = notes.instantiate()
			add_child(i)
			i.expected_time     = delta_sum_ + 1.0
			i.global_rotation   = s.node.global_rotation
			i.global_position.y = 125
			i.global_position.x = s.node.global_position.x + s.diff
			last_note = s
			s.queue.push_back(i)
		else:
			beatSkip += 1
			
func missed():
	get_tree().get_nodes_in_group("combo")[0].total_combo = 1
	get_tree().get_nodes_in_group("life")[0].total_lives -= 1
	if get_tree().get_nodes_in_group("life")[0].total_lives == 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")		
	
func hit():
	get_tree().get_nodes_in_group("combo")[0].total_combo *= 2
	get_tree().get_nodes_in_group("score")[0].total_score += (get_tree().get_nodes_in_group("combo")[0].total_combo *  19)
	print("HIT")

