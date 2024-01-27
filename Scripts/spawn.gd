extends Marker2D

var node_scene = preload("res://Scenes/note.tscn")



@onready var conductor = $"../conductor"


var spawned_nodes = [] 
var INSIDE = false
var is_paused = false 

func _ready():
	conductor.beat.connect(_on_beat)
	
func _on_beat(song: Song):
	if not is_paused:
		var spawned_node = node_scene.instantiate()
		spawned_nodes.append(spawned_node)
		add_child(spawned_node)
		spawned_node.global_position = position

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


