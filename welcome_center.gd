extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if Flags.special=="ufo":
		Flags.tne.addEvent("spacetime","level")
		return

	Flags.tne.addEvent("next")
#		Flags.effect="win"
