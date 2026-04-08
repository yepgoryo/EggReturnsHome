extends Area2D

func _on_body_enter(body):
	if body.get_name() == "Egg" or body.get_name() == "EggFalls":
		body.destroy_egg_ending()
