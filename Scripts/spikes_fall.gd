extends Area2D

@export var motion = float()
@export var delay = 100
var speed = 500
var delayed = false
var stopped = false
var timer = 0
var startpos = Vector2()

func _ready():
	startpos = get_position()
	if motion < 0:
		speed = - speed
	set_physics_process(true)

func _on_body_enter(body):
	if body.get_name() == "Egg":
		body.respawn(3)

func _physics_process(delta):
	var pos = get_position()
	if not delayed:
		if motion > 0:
			if get_position().y < startpos.y:
				delayed = true
				stopped = true
			elif get_position().y > (startpos.y + motion):
				delayed = true
				stopped = true
		elif motion < 0:
			if get_position().y > startpos.y:
				delayed = true
				stopped = true
			elif get_position().y < (startpos.y + motion):
				delayed = true
				stopped = true
	if delayed:
		set_position(startpos)
		timer = timer + 1
		if timer == delay:
			stopped = false
		if timer > delay:
			delayed = false
			timer = 0
	if not stopped:
		pos += Vector2(0, speed) * delta
		set_position(pos)
