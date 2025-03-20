extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation="bf"+str(Flags.rng.randi_range(1,2))
	scale.y=.65
	scale.x=.65
	$AnimatedSprite2D.offset.y=75
