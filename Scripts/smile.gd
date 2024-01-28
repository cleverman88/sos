extends Node2D



@export var pressed : bool = false:
	get:
		return pressed
	set(value):
		pressed = value
		
		
@export var color = Color.GRAY

func set_pressed(value:bool) -> void:
	pressed = value

func _ready():
	pass

func _process(delta:float) -> void:
	if pressed:
		modulate = lerp(modulate, color, 1.0)
	else:
		modulate = lerp(modulate, Color.GRAY, delta * 10.0)
