extends RigidBody2D

@export var Stopped = false
@export var audioStopped = false

var floor_times = 0
var found_floor
var start_position

var changePosition = false
var newPosition = Vector2(0, 0)
var enteredTeleport = false
var startedTeleporting = false

var jump_left = false
var jump_right = false
var high_jump = false

## For endings
var eggEndingCrack = false

@export var MakeJump = false
@export var StopTime = false
@export var RestoreTime = false
@export var LoopSprites = false
@export var LoopFrequency = 20

var Loops = 0
var Jumped = false
var TimeStopped = false
var TimeRestored = false
## End For Endings

var jumpInterval = 10
var jumpTimer = 10
var jumping = false
var jumpingNotFoundFloor = false

var resetHigh = true

var respawning = false

func _ready():
	start_position = Vector2(get_position().x, get_position().y)
	if get_node("/root/AutoLoad").SceneID > 8:
		crack_egg()

func _init():
	set_physics_process(true)

func _physics_process(_delta):
	for snd in get_node("EggSounds").get_children():
		snd.set_volume_linear(get_node("/root/AutoLoad").SoundVolume)
	
	## For Endings
	if LoopSprites:
		Loops = Loops + 1
		if Loops >= LoopFrequency:
			if get_node("EggSprite").is_visible():
				get_node("EggSprite").hide()
				get_node("StrangerSprite").show()
			else:
				get_node("StrangerSprite").hide()
				get_node("EggSprite").show()
			Loops = 0
	## End For Endings

func relay_input_press(input):
	var cancel_event = InputEventAction.new()
	cancel_event.action = input
	cancel_event.pressed = true
	Input.parse_input_event(cancel_event)

func relay_input_release(input):
	var cancel_event = InputEventAction.new()
	cancel_event.action = input
	cancel_event.pressed = false
	Input.parse_input_event(cancel_event)

func relay_input_just_press(input):
	relay_input_press(input)
	relay_input_release(input)

func _input(event: InputEvent) -> void:
	jump_left = Input.is_action_just_pressed("jump_left")
	jump_right = Input.is_action_just_pressed("jump_right")
	high_jump = Input.is_action_pressed("high_jump")
	
	if (event is InputEventMouseButton or event is InputEventScreenTouch) and event.is_pressed():
		var screenSize = get_viewport().get_visible_rect().size
		if event.position.x < screenSize.x * 0.2 and event.position.y < screenSize.y * 0.5:
			resetHigh = true
			relay_input_press("high_jump")
			relay_input_just_press("jump_left")
		elif event.position.x < screenSize.x * 0.2 and event.position.y > screenSize.y * 0.5:
			relay_input_just_press("jump_left")
		elif event.position.x > screenSize.x - (screenSize.x * 0.2) and event.position.y < screenSize.y * 0.5:
			resetHigh = true
			relay_input_press("high_jump")
			relay_input_just_press("jump_right")
		elif event.position.x > screenSize.x - (screenSize.x * 0.2) and event.position.y > screenSize.y * 0.5:
			relay_input_just_press("jump_right")

func _integrate_forces(state):
	if jumpTimer < jumpInterval:
		jumpTimer += 1
	
	if audioStopped:
		get_node("/root/AutoLoad/Audio").stop()
	
	## For Endings
	if MakeJump and not Jumped:
		get_node("EggSounds/Jump").play()
		set_axis_velocity(Vector2(200, -500))
		Jumped = true
	
	if StopTime and not TimeStopped:
		Engine.set_time_scale(0.03)
		TimeStopped = true
	
	if RestoreTime and not TimeRestored:
		Engine.set_time_scale(1)
		TimeRestored = true
	## End for Endings
	
	if eggEndingCrack:
		eggEndingCrack = false
		get_node("CollisionPolygon2D").call_deferred("set_disabled", true)
		set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
		call_deferred("set_freeze_enabled", true)
		set_rotation(0)
		get_node("CollisionPolygon2D").set_position(Vector2(0, 600))
		get_node("EggSprite").set_texture(load("res://Sprites/Elements/Egg/EggPart_1.png"))
		get_node("/root/Main/EggPart").show()
		get_node("/root/Main/EggPart1").show()
		get_node("/root/Main/EggPart2").show()
		get_node("/root/Main/EggPart").change_position(Vector2((get_position().x + 33), 632))
		get_node("/root/Main/EggPart1").change_position(Vector2((get_position().x + 32), 647))
		get_node("/root/Main/EggPart2").change_position(Vector2((get_position().x - 27), 643))
		get_node("/root/Main/EggPart").change_axis_velocity(Vector2(150, -100))
		get_node("/root/Main/EggPart1").change_axis_velocity(Vector2(300, -90))
		get_node("/root/Main/EggPart2").change_axis_velocity(Vector2(-120, -10))
		get_node("EggSounds/Fall").play()
		if has_node("/root/Main/EndingScreen/AnimationPlayer"):
			get_node("/root/Main/EndingScreen/AnimationPlayer").play("EndScreen")
	
	if enteredTeleport:
		if !startedTeleporting:
			startedTeleporting = true
			set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
			call_deferred("set_freeze_enabled", true)
			set_rotation(0)
		else:
			get_node("EggSprite").rotate(0.005)
			move_local_y(-0.8)
	if changePosition:
		changePosition = false
		set_position(newPosition)
	found_floor = false
	for x in range(state.get_contact_count()):
		var ci = state.get_contact_local_normal(x)
		if ci.dot(Vector2(0, - 1)) > 0.3:
			found_floor = true
	
	if respawning:
		respawning = false
	
	if not found_floor and jumpTimer == jumpInterval:
		jumpingNotFoundFloor = true
	
	if (jumping and jumpingNotFoundFloor) or jumpTimer == jumpInterval:
		jumping = false

	if found_floor and Stopped == false and not jumping:
		if high_jump:
			if jump_left:
				jumping = true
				jumpTimer = 0
				jumpingNotFoundFloor = false
				get_node("EggSounds/Jump2").play()
				set_angular_velocity(get_angular_velocity()-1)
				if get_linear_velocity().x > 0:
					set_axis_velocity(Vector2((-200 + -(get_linear_velocity().x * 0.6)), -800))
				else:
					set_axis_velocity(Vector2(-200, -800))
			elif jump_right:
				jumping = true
				jumpTimer = 0
				jumpingNotFoundFloor = false
				get_node("EggSounds/Jump2").play()
				set_angular_velocity(get_angular_velocity()+1)
				if get_linear_velocity().x < 0:
					set_axis_velocity(Vector2((200 - (get_linear_velocity().x * 0.6)), -800))
				else:
					set_axis_velocity(Vector2(200, -800))
			if resetHigh:
				relay_input_release("high_jump")
		else:
			if jump_left:
				jumping = true
				jumpTimer = 0
				jumpingNotFoundFloor = false
				get_node("EggSounds/Jump2").play()
				set_angular_velocity(get_angular_velocity()-1)
				if get_linear_velocity().x > 0:
					set_axis_velocity(Vector2((-200 + -(get_linear_velocity().x * 0.6)), -500))
				else:
					set_axis_velocity(Vector2(-200, -500))
			elif jump_right:
				jumping = true
				jumpTimer = 0
				jumpingNotFoundFloor = false
				get_node("EggSounds/Jump2").play()
				set_angular_velocity(get_angular_velocity()+1)
				if get_linear_velocity().x < 0:
					set_axis_velocity(Vector2((200-(get_linear_velocity().x * 0.6)), -500))
				else:
					set_axis_velocity(Vector2(200, -500))
	if get_linear_velocity().x > 1000:
		set_axis_velocity(Vector2(1000, get_linear_velocity().y))
	elif get_linear_velocity().x < -1000:
		set_axis_velocity(Vector2(-1000, get_linear_velocity().y))
	if get_linear_velocity().y > 1000:
		set_axis_velocity(Vector2(get_linear_velocity().x, 1000))
	elif get_linear_velocity().y < -1000:
		set_axis_velocity(Vector2(get_linear_velocity().x, -1000))

func respawn(respawn_type):
	respawning = true
	get_node("/root/AutoLoad").reset_timer()
	get_node("/root/AutoLoad").Data_TotalDeaths = get_node("/root/AutoLoad").Data_TotalDeaths + 1
	if respawn_type == 2:
		get_node("/root/AutoLoad").Data_SpikesDeaths = get_node("/root/AutoLoad").Data_SpikesDeaths + 1
	elif respawn_type == 3:
		get_node("/root/AutoLoad").Data_FallingSpikesDeaths = get_node("/root/AutoLoad").Data_FallingSpikesDeaths + 1
	get_node("/root/AutoLoad").save_data()
	if get_node("/root/AutoLoad").SceneID == 10:
		get_node("EggSounds/Death").play()
		get_node("/root/AutoLoad").load_scene_start("res://Scenes/lvl_10.tscn")
	elif get_node("/root/AutoLoad").SceneID == 20:
		get_node("EggSounds/Death").play()
		get_node("/root/AutoLoad").load_scene_start("res://Scenes/lvl_20.tscn")
	else:
		if has_node("/root/Main/Teleport"):
			get_node("/root/Main/Teleport").level_timer_delta = 0
		get_node("EggSounds/Death").play()
		get_node("AnimationPlayer").play("EggDead")
		set_linear_velocity(Vector2(0, 0))
		set_angular_velocity(0)
		set_rotation(-75.9)
		change_position(start_position)

func change_position(pos):
	newPosition = pos
	changePosition = true

func enter_teleport(teleportPosition):
	enteredTeleport = true
	change_position(teleportPosition)

func crack_egg():
	get_node("EggSprite").set_texture(load("res://Sprites/Elements/Egg/CrackedEgg.png"))
	
func destroy_egg_ending():
	eggEndingCrack = true
