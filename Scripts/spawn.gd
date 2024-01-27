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
				hit()
			else:
				missed()
			spawned_nodes.pop_front().queue_free()  # Remove the spawned node


func _on_mic_stand_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	INSIDE = true
	
	
func _on_mic_stand_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	# If the node is not hit it should just vanish 
	INSIDE = false # Replace with function body.
	if len(spawned_nodes) > 0:
		missed()
		spawned_nodes.pop_front().queue_free()  # Remove the spawned node


func missed():
	print("MISSED")
	
func hit():
	print("HIT")
