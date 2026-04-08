extends CanvasLayer

var showingHint = false

func _ready() -> void:
	if OS.get_name() == "Android":
		get_node("/root/Main/IndicatorObject1/Hint").hide()
		get_node("/root/Main/IndicatorObject2").hide()
		show_hint(1)

func _init() -> void:
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is not InputEventMouseMotion and showingHint:
		showingHint = false
		Engine.set_time_scale(1)
		get_node("Hint1").hide()
		get_node("Hint2").hide()

func show_hint(num):
	if OS.get_name() == "Android":
		showingHint = true
		if num == 2:
			get_node("Hint2").show()
		else:
			get_node("Hint1").show()
		Engine.set_time_scale(1e-15)
