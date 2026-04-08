extends Node2D

@export var motion = float()
@export var enabled = true
@export var speed = 150
var delayed = false
var stopped = false
var timer = 0
var startpos = Vector2()
var cycle = 7.0
var accum = 0.0

func _ready():
	startpos = get_node("EnemyMoving").get_position()
	
	
	set_position(Vector2((get_position().x + (motion / 2)), get_position().y))
	set_physics_process(true)


func _testfunc(delta):
	if enabled:
		var pos = get_position()
		var rot = get_rotation()
		if not delayed:
				if motion > 0:
					if (get_position().x < startpos.x):
						delayed = true
						stopped = true
					elif (get_position().x > (startpos.x + motion)):
						delayed = true
						stopped = true
				elif motion < 0:
					if get_position().x > startpos.x:
						delayed = true
						stopped = true
					elif get_position().x < (startpos.x + motion):
						delayed = true
						stopped = true
		if delayed:
			timer = timer + 1
			if timer == 200:
				speed = - speed
				stopped = false
			if timer > 200:
				delayed = false
				timer = 0
		if not stopped:
			pos += Vector2(speed, 0) * delta
			set_position(pos)
		set_rotation(get_rotation() - 0.009)

func _physics_process(delta):
	accum += delta * (1.0 / cycle) * PI * 2.0
	accum = fmod(accum, PI * 2.0)
	var d = sin(accum)
	var xf = Transform2D()
	xf[2] = Vector2((motion / 2), 0) * d
	get_node("EnemyMoving").set_transform(xf)
	get_node("EnemyMoving/Sprite2D").set_rotation(get_node("EnemyMoving/Sprite2D").get_rotation() - 0.009)
