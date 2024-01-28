extends Sprite2D

@export var expected_time = 0.0

var state_ := ""

func test_hit(time:float) -> bool:
	if abs(expected_time - time) < 0.2:
		return true
	return false

func test_miss(time:float) -> bool:
	if time > expected_time + 0.2:
		return true
	return false

func hit(position_to_freeze:Vector2) -> void:
	state_ = "hit"
	global_position = position_to_freeze
	
func miss() -> void:
	state_ = "miss"

func _process(delta):
	if state_ == "hit":
		queue_free()
		return

	global_position.y += delta * 350
		
	if state_ == "miss":
		if global_position.y > 500:
			queue_free()
