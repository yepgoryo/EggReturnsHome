extends CharacterBody2D

@export var motion = Vector2()
@export var enabled = true
@export var speed = 150
@export var delay = 100
var delayed = false
var stopped = false
var timer = 0
var startpos = Vector2()

func _ready():
	startpos = get_position()
	if motion.x == 0 and motion.y < 0 or motion.y == 0 and motion.x < 0:
		speed = -speed
	set_physics_process(true)

func _physics_process(delta):
	if enabled:
		var pos = get_position()
		if not delayed:
			if motion.x == 0:
				if motion.y > 0:
					if get_position().y < startpos.y:
						delayed = true
						stopped = true
						set_position(Vector2(get_position().x, startpos.y))
					elif get_position().y > (startpos.y + motion.y):
						delayed = true
						stopped = true
						set_position(Vector2(get_position().x, (startpos.y + motion.y)))
				elif motion.y < 0:
					if get_position().y > startpos.y:
						delayed = true
						stopped = true
						set_position(Vector2(get_position().x, startpos.y))
					elif get_position().y < (startpos.y + motion.y):
						delayed = true
						stopped = true
						set_position(Vector2(get_position().x, (startpos.y + motion.y)))
			elif motion.y == 0:
				if motion.x > 0:
					if get_position().x < startpos.x:
						delayed = true
						stopped = true
						set_position(Vector2(startpos.x, get_position().y))
					elif get_position().x > (startpos.x + motion.x):
						delayed = true
						stopped = true
						set_position(Vector2((startpos.x + motion.x), get_position().y))
				elif motion.x < 0:
					if get_position().x > startpos.x:
						delayed = true
						stopped = true
						set_position(Vector2(startpos.x, get_position().y))
					elif get_position().x < (startpos.x + motion.x):
						delayed = true
						stopped = true
						set_position(Vector2((startpos.x + motion.x), get_position().y))
		if delayed:
			timer = timer + 1
			if timer == delay:
				speed = -speed
				stopped = false
			if timer > delay:
				delayed = false
				timer = 0
		if not stopped:
			if motion.x == 0:
				pos += Vector2(0, speed) * delta
				set_position(pos)
			elif motion.y == 0:
				pos += Vector2(speed, 0) * delta
				set_position(pos)
