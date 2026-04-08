extends Node

@export var CanExit = false

func _ready():
	set_process_input(true)

func _input(event):
	if CanExit and event is not InputEventMouseMotion:
		if get_node("/root/AutoLoad").SceneID == 301:
			get_node("/root/AutoLoad").load_scene_start("res://Scenes/MainMenu.tscn")
		elif get_node("/root/AutoLoad").SceneID == 302:
			get_node("/root/AutoLoad").load_scene_start("res://Scenes/lvl_31.tscn")
		elif get_node("/root/AutoLoad").SceneID == 40:
			get_node("/root/AutoLoad").load_scene_start("res://Scenes/MainMenu.tscn")
