extends Node2D

@onready var pause_menu = $PauseMenu
@onready var rect = $ColorRect
var paused = false 

@onready var notes = preload("res://Scenes/note_new.tscn")

var delta_sum_ := 0.0

var left := []

@onready var stuff := {
	128: {
		"key": "ui_select",
		"node": get_node("note/space"),
		"queue": []
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
					print("hit")
				else:
					print("TOO EARLY")
			else:
				print("WUT??")
				
		if not (len(s.queue) == 0):
			if s.queue.front().test_miss(delta_sum_):
				s.queue.pop_front().miss()
				print("miss")

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
	if s:
			var i = notes.instantiate()
			rect.add_child(i)
			i.expected_time     = delta_sum_ + 1.0
			i.global_rotation   = s.node.global_rotation
			i.global_position.y = 125
			i.global_position.x = s.node.global_position.x
			s.queue.push_back(i)
