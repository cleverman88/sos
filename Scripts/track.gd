extends Node2D

# Define the speed and the max length of the lines
var speed = 5
var max_length = 400 # Adjust this to how long you want the lines to be

# Holds the Line2D nodes
var lines = []

func _ready():
	var line = $track_1
	lines.append(line)
	line.points.append(Vector2())
	line = $track_2
	lines.append(line)
	line.points.append(Vector2()) 
	line = $track_3
	lines.append(line)
	line.points.append(Vector2()) 


func _process(delta):
	for line in lines:
		if line.points.size() > 0:
			var last_point = line.points[line.points.size() - 1]
			var new_x = min(last_point.x + speed * delta, max_length)
			var new_point = Vector2(new_x, last_point.y)
			
			# Update the line's end point
			if line.points.size() == 1:
				line.points.append(new_point)
			else:
				line.points[line.points.size() - 1] = new_point
			
			# Debug print
			print("Line: ", line.name, " New Point: ", new_point)
