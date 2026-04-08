extends RigidBody2D

var cracked = false

var EggCracked

@export var MakeJump = false
@export var StopTime = false
@export var RestoreTime = false
@export var LoopSprites = false
@export var LoopFrequency = 60

var Loops = 0
var Jumped = false
var TimeStopped = false
var TimeRestored = false

var EggSprite

var EggSprite2

func _ready():
	if get_node("/root/AutoLoad").SceneID == 301:
		get_node("/root/AutoLoad").Data_ReachedBadEnding = true
		get_node("/root/AutoLoad").save_data()
	EggSprite = get_node("Sprite2D")
	EggSprite2 = get_node("Sprite1")
	if has_node("/root/Main/EndingScreen/AnimationPlayer"):
		get_node("EggSoundsFall").play("jump")
	get_node("/root/Main/EggPart").hide()
	get_node("/root/Main/EggPart1").hide()
	get_node("/root/Main/EggPart2").hide()
	EggCracked = load("res://Sprites/Elements/Egg/EggPart_1.png")
	set_process(true)
	set_physics_process(true)

func _process(_delta):
	if MakeJump and not Jumped:
		get_node("EggSoundsFall").play("jump")
		set_axis_velocity(Vector2(200, - 500))
		Jumped = true
	
	if StopTime and not TimeStopped:
		Engine.set_time_scale(0.03)
		TimeStopped = true
	
	if RestoreTime and not TimeRestored:
		Engine.set_time_scale(1)
		TimeRestored = true

func _physics_process(_delta):
	if LoopSprites:
		Loops = Loops + 1
		if Loops >= LoopFrequency:
			if EggSprite.is_visible():
				EggSprite.hide()
				EggSprite2.show()
			else:
				EggSprite2.hide()
				EggSprite.show()
			Loops = 0

func _crack_egg():
	if not cracked:
		set_freeze_mode(RigidBody2D.FREEZE_MODE_KINEMATIC)
		set_rotation(0)
		get_node("CollisionPolygon2D").set_position(Vector2(0, 600))
		get_node("/root/Main/EggPart").set_position(Vector2((get_position().x + 33), 609))
		get_node("/root/Main/EggPart1").set_position(Vector2((get_position().x + 32), 624))
		get_node("/root/Main/EggPart2").set_position(Vector2((get_position().x - 27), 620))
		get_node("/root/Main/EggPart").set_axis_velocity(Vector2(400, - 240))
		get_node("/root/Main/EggPart1").set_axis_velocity(Vector2(240, - 90))
		get_node("/root/Main/EggPart2").set_axis_velocity(Vector2( - 300, - 10))
		get_node("/root/Main/EggPart").show()
		get_node("/root/Main/EggPart1").show()
		get_node("/root/Main/EggPart2").show()
		get_node("Sprite2D").set_texture(EggCracked)
		set_position(Vector2(get_position().x, 649))
		get_node("EggSoundsFall").play("Sound_Fall")
		if has_node("/root/Main/EndingScreen/AnimationPlayer"):
			get_node("/root/Main/EndingScreen/AnimationPlayer").play("EndScreen")
		cracked = true
