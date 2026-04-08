extends AnimationPlayer

@export var LoadNextLevel = false

@export var NextLevel = String()

var SceneLoads = false

func _ready():
	if get_node("/root/Main").get_scene_file_path() != "res://Scenes/SplashScreen.tscn":
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_physics_process(true)
	pass

func _physics_process(_delta):
	if LoadNextLevel and not SceneLoads:
		SceneLoads = true
		get_node("/root/AutoLoad").load_scene_start(NextLevel)
