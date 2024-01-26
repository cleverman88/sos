extends Area2D

# Define the speed at which the Area2D will move to the right
var speed = 250 # pixels per second

func _process(delta):
	# Calculate the movement
	var movement = speed * delta
	# Update the position
	position.x += movement
