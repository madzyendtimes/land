extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation="b"+str(Flags.rng.randi_range(1,4))
	if Flags.rng.randi_range(0,1)>0:
		$AnimatedSprite2D.flip_h=true
	if Flags.rng.randi_range(0,1)>0:
		$AnimatedSprite2D.flip_v=true
