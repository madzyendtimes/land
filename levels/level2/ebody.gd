extends Area2D

var kind="enemy"
var home
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	kind=get_parent().kind
	
	pass # Replace with function body.

func makefriend(sp):
	print("make friend")
	get_parent().makefriend(sp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
