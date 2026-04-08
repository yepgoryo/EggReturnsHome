extends AnimationPlayer

@export var CameraChange = false

var CameraChanged = false

func _ready():
	set_process(true)
	pass

func _process(delta):
	if CameraChange and not CameraChanged:
		var cam = get_node("/root/Main/Camera2D")
		get_node("/root/Main/Egg").add_child(cam)
		get_node("/root/Main").remove_child(cam)
		get_node("/root/Main/Egg/Camera2D").set_rotation(0)
		get_node("/root/Main/Egg/Camera2D").set_position(Vector2(0, 0))
		CameraChanged = true
