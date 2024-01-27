extends ColorRect

@onready var conductor = $"../conductor"
@onready var p = $AnimationPlayer

var last_bar = -1
func _ready():
	conductor.beat.connect(_on_beat)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_beat(barsAndBeat: Vector2):
	print(last_bar,barsAndBeat.x)
	if last_bar != barsAndBeat.x:
		p.play("pulse")
		last_bar = barsAndBeat.x
