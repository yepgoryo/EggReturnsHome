extends AnimationPlayer

func _ready() -> void:
	if get_node("/root/AutoLoad").sceneReloaded:
		play("Move")
	else:
		get_node("/root/AutoLoad").reachedTeleport = true
		get_node("/root/Main/Camera2D").set_enabled(true)
		get_node("/root/Main/Egg/Camera2D").set_enabled(false)
		play("MoveStartScene")

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion:
		get_node("/root/AutoLoad").reachedTeleport = false
		get_node("/root/Main/Camera2D").set_enabled(false)
		get_node("/root/Main/Egg/Camera2D").set_enabled(true)
		play("Move")
