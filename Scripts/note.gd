extends Area2D

# Define the velocity (pixels per second). Adjust x for horizontal speed.
var velocity = Vector2(100, 0)  # Move to the right at 100 pixels per second.
var done_out = false
	
func _ready():
	# If you need to initialize something
	pass

func _process(delta):
	# Update position based on velocity and delta
	#position += velocity * delta
	pass
