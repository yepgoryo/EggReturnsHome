extends Area2D
var cracked = false

var CrackedEgg

func _ready():
	CrackedEgg = load("res://Sprites/Elements/Egg/CrackedEgg.png")

func _on_body_enter(body):
	if body.get_name() == "Egg" and not cracked:
		get_node("/root/Main/Egg/EggSprite").set_texture(CrackedEgg)
		get_node("/root/Main/Egg/EggSounds/Fall").play()
		cracked = true
