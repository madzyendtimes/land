extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatedSprite2D.animation="f"+str(Flags.rng.randi_range(1,9))
	if $AnimatedSprite2D.animation!="f2" && $AnimatedSprite2D.animation!="f5":
		
		$AnimatedSprite2D.flip_h=Flags.rng.randi_range(0,1)>0
