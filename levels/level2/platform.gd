extends Area2D
var type="p1"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type="p"+str(Flags.rng.randi_range(1,4))
	if Flags.rng.randi_range(0,1)>0:
		$AnimatedSprite2D.flip_h=true



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
#	if area.name.contains("pfeet"):
		#print("collide")
		#area.setpos(position.y)
	pass
