extends Marker2D

var node_scene = preload("res://Scenes/note.tscn")

@onready var conductor = $"../conductor"


var spawned_nodes = [] 
var INSIDE = false
	

func _ready():
	conductor.beat.connect(_on_beat)
	
func _on_beat(barsAndBeat: Vector2):
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
			else:
				missed(spawned_nodes[-1])
			spawned_nodes.pop_front().queue_free()  # Remove the spawned node


func _on_mic_stand_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	INSIDE = true


func missed(node):
	get_tree().get_nodes_in_group("combo")[0].total_combo = 1
	get_tree().get_nodes_in_group("life")[0].total_lives -= 1
	print("MISSED")
	
func hit(node):
	get_tree().get_nodes_in_group("combo")[0].total_combo *= 2
	get_tree().get_nodes_in_group("score")[0].total_score += (get_tree().get_nodes_in_group("combo")[0].total_combo *  19)
	print("HIT")



func _on_missed_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	INSIDE = false # Replace with function body.
	if len(spawned_nodes) > 0:
		missed(spawned_nodes[-1])
		spawned_nodes.pop_front().queue_free()  # Remove the spawned node
		
