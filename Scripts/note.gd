extends Area2D

var target_position = Hack.HIT_POSITION
var start_position = Vector2()
var duration = 0.25  # Duration in seconds to reach the target
var elapsed_time = 0  # Time elapsed since the movement started
var moving = false

func _ready():
	start_position = position  # Store the initial position

func _process(delta):
	if moving:
		elapsed_time += delta  # Increment the time elapsed
		var t = min(elapsed_time / duration, 1.0)  # Calculate the interpolation factor (from 0 to 1)
		position = start_position.lerp(target_position, t)  # Interpolate between start and target position
		
		if position == target_position:  # Stop moving when the target is reached
			moving = false
			elapsed_time = 0  # Reset the elapsed time for the next move

func _on_offset_timeout():
	moving = true
	elapsed_time = 0  # Reset the elapsed time
	start_position = position  # Update the start position
