extends Node2D

var hard

func _ready():
	hard = get_node("/root/AutoLoad").Data_HardMode
	if not hard:
		get_node("Easy").show()
		remove_child(get_node("Hard"))
	elif hard:
		get_node("Hard").show()
		remove_child(get_node("Easy"))
	pass
