extends Area2D

var player = false

func _on_body_enter(body):
	if body.get_name() == "Egg" and not player:
		player = true
		get_node("/root/Main/MobileHint").show_hint(2)
