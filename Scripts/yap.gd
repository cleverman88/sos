extends Node2D


# Called when the node enters the scene tree for the first time.
@onready var p = $AnimationPlayer
func _ready():
	p.play("yapping")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
