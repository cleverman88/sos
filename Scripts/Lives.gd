extends Node2D

var total_lives = 10
var prev_lives = total_lives

@onready var good = $Good
@onready var medium = $Medium
@onready var medium_animation = $MediumBoom/AnimationPlayer
@onready var bad_animation = $BadBoom/AnimationPlayer
@onready var bad = $Bad
@onready var boom = $boom
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if total_lives == 10:
		good.visible = true
		medium.visible = false
		bad.visible = false
		return
	if total_lives == 6 and prev_lives != total_lives:
		good.visible = false
		medium.visible = true
		bad.visible = false
		prev_lives = total_lives
		boom.play()
		medium_animation.play("expload")
		return
	if total_lives == 2 and prev_lives != total_lives:
		good.visible = false
		medium.visible = false
		bad.visible = true
		prev_lives = total_lives
		boom.play()
		bad_animation.play("expload")
		return

