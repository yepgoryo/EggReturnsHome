extends AudioStreamPlayer

func _ready():
	set_physics_process(true)

func _physics_process(_delta):
	set_volume_linear(get_node("/root/AutoLoad").SoundVolume)
