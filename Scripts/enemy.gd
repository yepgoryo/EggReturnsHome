extends Area2D

func _on_body_enter(body):
	if body.get_name() == "Egg":
		body.respawn(1)
