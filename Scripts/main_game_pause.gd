extends Node2D

@onready var pause_menu = $PauseMenu
var paused = false 

func _ready():
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
	else:
		pause_menu.show()
		
	paused = !paused


