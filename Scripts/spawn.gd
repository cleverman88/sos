extends Marker2D

const note_asset = preload("res://Scenes/note.tscn")



@onready var conductor = $"../conductor"


var spawned_nodes = [] 
var INSIDE = false
var is_paused = false 

const  minPathDuration = 0.2
var pathDuration = 0.5

func _ready():
	pathDuration = 0.5
	conductor.beat.connect(_on_beat)
	
func get_path_duration(speed_up = true):
	var d = pathDuration
	if speed_up:
		pathDuration = max(pathDuration - 0.001, minPathDuration)
	return d
	
func _on_beat(song: Song):
	if not is_paused:
		var nextBeatIn = song.get_duration_next_beat()
		var animationDuration = get_path_duration()
		var t = get_tree().create_timer(nextBeatIn - animationDuration)
		t.timeout.connect(func ():
			var spawned_node = note_asset.instantiate()
			spawned_nodes.append(spawned_node)
			add_child(spawned_node)
			spawned_node.global_position = position
			var a = spawned_node.get_node("AnimationPlayer")
			a.speed_scale = 0.5 / animationDuration
			a.play("note_move")
		)

func _input(event):
	if event.is_action_pressed("ui_right"):  # Check if the right arrow key was pressed
		if len(spawned_nodes) > 0:  # Check if there's a spawned node
			if INSIDE:
				INSIDE = false
				hit(spawned_nodes[-1])
			else:#
				missed(spawned_nodes[-1])
			spawned_nodes.pop_front().queue_free()  # Remove the spawned node
	if event.is_action_pressed("pause"):
		print("CALLED")
		toggle_pause()


func _on_mic_stand_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	INSIDE = true


func missed(node):
	get_tree().get_nodes_in_group("combo")[0].total_combo = 1
	get_tree().get_nodes_in_group("life")[0].total_lives -= 1
	var track = get_node('miss')
	track.play()
	
	
	if get_tree().get_nodes_in_group("life")[0].total_lives == 0:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		
	
	
	
	
func hit(node):
	get_tree().get_nodes_in_group("combo")[0].total_combo *= 2
	get_tree().get_nodes_in_group("score")[0].total_score += (get_tree().get_nodes_in_group("combo")[0].total_combo *  19)
	print("HIT")
	var rng = RandomNumberGenerator.new()
	var track = get_node('hit_'+str(rng.randi_range(0,3)))
	track.play()



func _on_missed_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	INSIDE = false # Replace with function body.
	if len(spawned_nodes) > 0:
		missed(spawned_nodes[-1])
		spawned_nodes.pop_front().queue_free()  # Remove the spawned node
		
func toggle_pause():
	print("BRUH")
	is_paused = !is_paused  # Toggle the pause state
	get_tree().paused = is_paused  # Pause the game


