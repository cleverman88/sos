extends Area2D


# This script will handle the interactions of the notes to the body, we want to work on making this as precise as 
# possible, but we may work on this one down the line

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_collision_shape_2d_child_entered_tree(node):
	print("ENTERED")
