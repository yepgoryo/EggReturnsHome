extends Sprite2D

@export var SpriteXbox = String()

@export var SpritePS = String()

func _ready():
	if Input.get_connected_joypads().size() > 0:
		if Input.get_joy_name(0) == "PS1 USB" or Input.get_joy_name(0) == "PS2 USB" or Input.get_joy_name(0) == "PS3 DualShock" or Input.get_joy_name(0) == "PS3 Controller" or Input.get_joy_name(0) == "PS4 Controller" or Input.get_joy_name(0) == "PS3 Controller (Bluetooth)" or Input.get_joy_name(0) == "PS4 Controller (Bluetooth)":
			set_texture(load("res://Sprites/Hints/" + SpritePS + ".png"))
		else:
			set_texture(load("res://Sprites/Hints/" + SpriteXbox + ".png"))
