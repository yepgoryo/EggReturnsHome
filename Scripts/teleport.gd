extends Area2D

@export var Ending = 0
@export var activated = true

var flash
var egg
var teleporting = false
var start_timer = false
var end_timer = false
var timer = 0
var timer_delay = 100
var level_timer_delta = 0
var level_timer = 0
var reached_teleport = false
var timer_text = ""
var seconds = 0
var minutes = 0
var hours = 0
var milliseconds = 0
var lvl_int

@export var moveAway = false
var MoveTimes = 0

func _ready():
	set_process(true)
	set_physics_process(true)
	lvl_int = get_node("/root/AutoLoad").SceneID
	flash = get_node("/root/AutoLoad/Flash")
	if lvl_int == 30 or lvl_int == 31 or lvl_int == 6 or lvl_int == 10 or lvl_int == 20 or lvl_int == 30 or lvl_int == 40:
		get_node("/root/AutoLoad/TimerLayer").hide()
	else:
		get_node("/root/AutoLoad/TimerLayer").show()

func _on_Teleport_body_enter(body):
	if body.get_name() == "Egg" and not teleporting and activated and (not moveAway or (moveAway and MoveTimes == 3)):
		if not body.respawning:
			get_node("/root/AutoLoad").reached_teleport()
			reached_teleport = true
			body.enter_teleport(Vector2(get_position().x, get_position().y - 80))
			egg = body
			teleporting = true
			start_timer = true
			egg.get_node("EggSounds/Teleport").play()
	
	if moveAway:
		if body.get_name() == "Egg" and MoveTimes < 3:
			if not body.respawning:
				set_position(Vector2((get_position().x + 384), get_position().y))
				MoveTimes = MoveTimes + 1
				print(MoveTimes)

func _physics_process(_delta):
	if start_timer == true and end_timer == false:
		timer += 1
		if timer == 50 and flash.get_node("AnimationPlayer").get_current_animation() != "MakeWhite":
			flash.get_node("AnimationPlayer").play("MakeWhite")
		elif timer == 150:
			teleporting = false
			start_timer = false
			end_timer = true
			timer = 0
			if Ending == 0:
				get_node("/root/AutoLoad").load_scene_start("res://Scenes/lvl_" + str(get_node("/root/AutoLoad").SceneID + 1) + ".tscn", true)
			else:
				get_node("/root/AutoLoad").load_scene_start("res://Scenes/lvl_30" + str(Ending) + ".tscn", true)
