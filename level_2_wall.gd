extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation="d"+str(Flags.rng.randi_range(1,7))
