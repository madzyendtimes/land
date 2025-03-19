extends Area2D
var speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	speed=get_parent().speed
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
