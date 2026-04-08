extends AnimationPlayer

@export var blink = false
var blinked = false

func _ready():
	set_process(true)
	pass

func _process(_delta):
	if blink and not blinked:
		get_node("/root/AutoLoad/Flash/AnimationPlayer").play("MakeBlink")
		blinked = true
