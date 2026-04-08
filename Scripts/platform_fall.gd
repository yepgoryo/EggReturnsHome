extends Area2D

func _on_body_enter(body):
	if get_node("Platform/AnimationPlayer").get_current_animation() != "PlatformFall" and body.get_name() == "Egg":
		get_node("Platform/AnimationPlayer").play("PlatformFall")
	pass
