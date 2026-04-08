extends Area2D

@export var spikes = false

func _on_body_enter(body):
	if body.get_name() == "Egg":
		if not spikes:
			body.respawn(1)
		else:
			body.respawn(2)
	pass
