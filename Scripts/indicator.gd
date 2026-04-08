extends Area2D

@export var IndicatorId = 1
var player = false

func _on_body_enter(body):
	if body.get_name() == "Egg" and not player:
		player = true
		get_node("/root/Main/IndicatorObject" + str(IndicatorId) + "/AnimationPlayer").play("AnimPlay")
