extends Node

var SceneID
var CurrentScene = null

var GameAudio

var MusicVolume: float = 1.0
var SoundVolume: float = 1.0

var SaveData = []

var Data_LevelsScores = []
var Data_TotalDeaths = 0
var Data_SpikesDeaths = 0
var Data_FallingSpikesDeaths = 0
var Data_Levels = 0
var Data_GameCompleted = null
var Data_ReachedBadEnding = null
var Data_HardMode = null

var CompletedGameBefore = false

var loadingStarted = false

var currentLoadingScene: String

var reachedTeleport = false

var levelTimerDelta = 0

var sceneReloaded = false

func _ready():
	GameAudio = [
		load("res://Audio/Music/Mozart - Oboe Concerto in C, K.314 271k 2 - II. Andantino (PD European Archive).ogg"),
		load("res://Audio/Music/Mozart - Piano Concerto no. 17 in G major - III. Allegretto (first part) (PD European Archive).ogg"),
		load("res://Audio/Music/Mozart - Violin Concerto no. 2 in D major, K. 211 - I. Allegro moderato (PD European Archive).ogg"),
		load("res://Audio/Music/Mozart - Piano Concerto no. 17 in G major - III. Allegretto (second part) (PD European Archive).ogg"),
		load("res://Audio/Music/Mozart - Oboe Concerto in C, K.314 271k - I. Allegro (PD European Archive).ogg"),
		load("res://Audio/Music/Mozart - String Quartet no. 19 in C major Dissonant, K. 465 (PD Musopen String Quartet).ogg"),
		load("res://Audio/Music/Mozart - Trio No.1 G major - II. Andante (PD European Archive).ogg"),
		load("res://Audio/Music/Mozart - Symphony No. 40 in G Minor, K. 550 - II. Andante (PD Czech National Symphony Orchestra).ogg"),
		load("res://Audio/Music/Mozart - Rondo No. 3 in A Minor, K. 511 (Reversed) (PD David H. Porter).ogg")
	]
	
	SceneID = get_scene_id(get_tree().get_current_scene().get_scene_file_path())
	load_audio()
	
	SaveData.push_back("Data_TotalDeaths")
	SaveData.push_back("Data_SpikesDeaths")
	SaveData.push_back("Data_FallingSpikesDeaths")
	SaveData.push_back("Data_Levels")
	SaveData.push_back("Data_GameCompleted")
	SaveData.push_back("Data_ReachedBadEnding")
	SaveData.push_back("Data_HardMode")
	SaveData.push_back("Data_LevelsScores")
	load_data()
	load_config()
	for i in range(0, 41):
		Data_LevelsScores.append(0)
	save_data()

	set_process_input(true)
	set_physics_process(true)

func reached_teleport():
	reachedTeleport = true
	if Data_LevelsScores[SceneID] == 0 or Data_LevelsScores[SceneID] > int(levelTimerDelta):
		Data_LevelsScores[SceneID] = int(levelTimerDelta)
		save_data()
	if (SceneID > Data_Levels):
		Data_Levels = SceneID
		save_data()
	levelTimerDelta = 0

func reset_timer():
	levelTimerDelta = 0

func _physics_process(delta):
	get_node("Audio").set_volume_linear(MusicVolume)
	
	if (reachedTeleport == false and SceneID != 30 and SceneID != 40):
		levelTimerDelta += delta * 1000
		var levelTimer = int(levelTimerDelta)
		var seconds = (levelTimer / 1000) % 60
		var minutes = (levelTimer / (1000 * 60)) % 60
		var hours = (levelTimer / (1000 * 60 * 60)) % 24
		var milliseconds = levelTimer / 100 % 10
		var timer_text = str(("%02d" % hours)) + "." + str(("%02d" % minutes)) + "." + str(("%02d" % seconds)) + "." + str(milliseconds)
		get_node("/root/AutoLoad/TimerLayer/Timer").set_text(str(timer_text))

func achievements():
	if Data_TotalDeaths >= 1:
		pass
		## Todo: Achievement "First Death"
	if Data_TotalDeaths >= 1000:
		pass
		## Todo: Achievement "Die. Respawn. Repeat."
	if Data_Levels >= 7:
		pass
		## Todo: Achievement "Stranger"
	if Data_FallingSpikesDeaths >= 100:
		pass
		## Todo: Achievement "Flying Death"
	if Data_Levels >= 11:
		pass
		## Todo: Achievement "What?!"
	if Data_Levels >= 21:
		pass
		## Todo: Achievement "Good Evening, Sir!"
	if Data_SpikesDeaths >= 100:
		pass
		## Todo: Achievement "Annoying Spikes"
	if Data_GameCompleted:
		pass
		## Todo: Achievement "Finally!"
	if Data_ReachedBadEnding:
		pass
		## Todo: Achievement "Oops..."
	if Data_HardMode and Data_GameCompleted and SceneID == 30:
		pass
		## Todo: Achievement "Hardcore Gamer"
	if Data_GameCompleted and not Data_HardMode and SceneID == 30:
		pass
		## Todo: Achievement "Casual Gamer"

func serialize_data(d, variable):
	d[variable] = var_to_str(get(variable))

func parse_data(d, variable):
	if d.has(variable):
		set(variable, str_to_var(d[variable]))

func save_data():
	var data = {}
	for i in SaveData:
		serialize_data(data, i)
	data = JSON.stringify(data)
	var f = FileAccess.open("user://gamedata.json", FileAccess.WRITE)
	f.store_string(data)
	f.close()

func load_data():
	if not FileAccess.file_exists("user://gamedata.json"):
		return
	var f = FileAccess.open("user://gamedata.json", FileAccess.READ)
	var data = {}
	var test_json_conv = JSON.new()
	test_json_conv.parse(f.get_as_text())
	data = test_json_conv.get_data()
	f.close()
	for i in SaveData:
		parse_data(data, i)

func _on_Back_pressed():
	if SceneID >= 1 and SceneID != 301 and SceneID != 302 and SceneID != 40 and OS.get_name() == "Android":
		get_node("/root/AutoLoad/LevelsMenu/ShowMenu").show()
	
	save_config()
	if has_node("/root/Main/Egg"):
		if not get_node("/root/Main/Egg").Stopped:
			if not get_node("LevelsMenu/Menu").is_visible():
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_node("LevelsMenu/Menu").show()
				Engine.set_time_scale(1e-15)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				get_node("LevelsMenu/Menu").hide()
				Engine.set_time_scale(1)
	else:
		if not get_node("LevelsMenu/Menu").is_visible():
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_node("LevelsMenu/Menu").show()
			Engine.set_time_scale(1e-15)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			get_node("LevelsMenu/Menu").hide()
			Engine.set_time_scale(1)
			save_config()

func _on_MainMenu_pressed():
	get_node("LevelsMenu/Menu").hide()
	Engine.set_time_scale(1)
	load_scene_start("res://Scenes/MainMenu.tscn", true)

func _on_Restart_pressed():
	get_node("LevelsMenu/Menu").hide()
	Engine.set_time_scale(1)
	load_scene_start("res://Scenes/lvl_" + str(SceneID) + ".tscn", true)

func load_config():
	var gameconf = ConfigFile.new()
	gameconf.load("user://settings.cfg")
	if not gameconf.has_section_key("Audio", "Sound"):
		gameconf.set_value("Audio", "Sound", 1)
		SoundVolume = 1
		gameconf.save("user://settings.cfg")
	else:
		SoundVolume = gameconf.get_value("Audio", "Sound")
	if not gameconf.has_section_key("Audio", "Music"):
		gameconf.set_value("Audio", "Music", 1)
		MusicVolume = 1.0
		gameconf.save("user://settings.cfg")
	else:
		MusicVolume = gameconf.get_value("Audio", "Music")

func save_config():
	var gameconf = ConfigFile.new()
	gameconf.load("user://settings.cfg")
	gameconf.set_value("Audio", "Sound", SoundVolume)
	gameconf.set_value("Audio", "Music", MusicVolume)
	gameconf.save("user://settings.cfg")

func load_scene_start(scenePath, withLoadingScreen: bool = false):
	## Just to make sure
	reachedTeleport = true
	levelTimerDelta = 0
	
	currentLoadingScene = scenePath
	loadingStarted = true
	
	ResourceLoader.load_threaded_request(scenePath)
	
	if withLoadingScreen:
		get_node("/root/AutoLoad/TimerLayer").hide()
		get_node("/root/AutoLoad/LoadingScreen").set_visible(true)
		get_node("/root/AutoLoad/LoadingScreen/EggLoadingScreen").play("StartLoading")

func load_scene_loaded() -> bool:
	var loaded = ResourceLoader.load_threaded_get_status(currentLoadingScene)
	if loaded == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
		loadingStarted = false
		return true
	return false

func _process(_delta):
	if loadingStarted:
		get_node("/root/AutoLoad/LoadingScreen/EggLoading").rotate(0.08)
		if load_scene_loaded():
			loadingStarted = false
			var loadedScene = ResourceLoader.load_threaded_get(currentLoadingScene).instantiate()
			load_scene_finish(currentLoadingScene, loadedScene)

func get_scene_id(scenePath) -> int:
	var scnId = 0
	if scenePath.replace("res://Scenes/", "").begins_with("lvl_"):
		scnId = int((scenePath.replace("res://Scenes/lvl_", "")).replace(".tscn", ""))
	else:
		if scenePath.replace("res://Scenes/", "") == "SplashScreen.tscn":
			scnId = -2
		elif scenePath.replace("res://Scenes/", "") == "MainMenu.tscn":
			scnId = -1
		elif scenePath.replace("res://Scenes/", "") == "Beginning.tscn":
			scnId = 0
	return scnId

func load_scene_finish(scenePath, sceneResLoaded):
	get_tree().change_scene_to_node(sceneResLoaded)
	
	reachedTeleport = false
	
	get_node("TimerLayer").hide()
	get_node("LoadingScreen/EggLoadingScreen").stop()
	get_node("LoadingScreen").set_visible(false)
	get_node("LevelsMenu/Menu/SettingsPanel/MusicScroll").set_value(MusicVolume)
	get_node("LevelsMenu/Menu/SettingsPanel/SoundScroll").set_value(SoundVolume)
	
	sceneReloaded = SceneID == get_scene_id(scenePath)

	SceneID = get_scene_id(scenePath)
	
	load_audio()
	
	if SceneID >= 1 and SceneID != 301 and SceneID != 302 and SceneID != 40 and OS.get_name() == "Android":
		get_node("/root/AutoLoad/LevelsMenu/ShowMenu").show()
	else:
		get_node("/root/AutoLoad/LevelsMenu/ShowMenu").hide()
	
	if SceneID != -1:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if SceneID == -1 or SceneID > 0:
		get_node("Flash/AnimationPlayer").play("MakeTransparent")

	if SceneID == 30:
		Data_GameCompleted = true
	if SceneID == 301:
		Data_ReachedBadEnding = true
		save_data()

func load_audio():
	if SceneID == -1:
		get_node("Audio").stop()
		get_node("Audio").set_stream(null)
	if SceneID == 0:
		if get_node("Audio").get_stream() != GameAudio[6]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[6])
			get_node("Audio").play()
	if SceneID >= 1 and SceneID <= 9:
		if get_node("Audio").get_stream() != GameAudio[0]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[0])
			get_node("Audio").play()
	if SceneID == 10:
		if get_node("Audio").get_stream() != GameAudio[1]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[1])
			get_node("Audio").play()
	if SceneID >= 11 and SceneID <= 19:
		if get_node("Audio").get_stream() != GameAudio[2]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[2])
			get_node("Audio").play()
	if SceneID == 20:
		if get_node("Audio").get_stream() != GameAudio[3]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[3])
			get_node("Audio").play()
	if SceneID >= 21 and SceneID <= 29:
		if get_node("Audio").get_stream() != GameAudio[4]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[4])
			get_node("Audio").play()
	if SceneID == 30:
		get_node("Audio").stop()
		get_node("Audio").set_stream(null)
	if SceneID == 31:
		if get_node("Audio").get_stream() != GameAudio[7]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[7])
			get_node("Audio").play()
	if SceneID < 40 and SceneID >= 32:
		if get_node("Audio").get_stream() != GameAudio[5]:
			get_node("Audio").stop()
			get_node("Audio").set_stream(GameAudio[5])
			get_node("Audio").play()
	if SceneID == 40:
		get_node("Audio").stop()
		get_node("Audio").set_stream(GameAudio[8])
		get_node("Audio").play()

func open_level_menu():
	if SceneID >= 1 and SceneID != 301 and SceneID != 302 and SceneID != 40:
		if has_node("/root/Main/Egg"):
			if not get_node("/root/Main/Egg").Stopped:
				if not get_node("LevelsMenu/Menu").is_visible():
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
					get_node("/root/AutoLoad/LevelsMenu/ShowMenu").hide()
					get_node("LevelsMenu/Menu").show()
					Engine.set_time_scale(1e-15)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
					get_node("LevelsMenu/Menu").hide()
					Engine.set_time_scale(1)
					save_config()
		else:
			if not get_node("LevelsMenu/Menu").is_visible():
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				get_node("/root/AutoLoad/LevelsMenu/ShowMenu").hide()
				get_node("LevelsMenu/Menu").show()
				Engine.set_time_scale(1e-15)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				get_node("LevelsMenu/Menu").hide()
				Engine.set_time_scale(1)
				save_config()

func _input(event):
	if event.is_action_pressed("open_level_menu"):
		open_level_menu()
	if get_node("LevelsMenu/Menu").is_visible():
		if event is InputEventMouseMotion:
			if (get_node("LevelsMenu/Menu").get_viewport().gui_get_focus_owner() != null):
				get_node("LevelsMenu/Menu").get_viewport().gui_get_focus_owner().release_focus()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_node("LevelsMenu/Menu/XinputControllerHint").hide()
			get_node("LevelsMenu/Menu/DinputControllerHint").hide()
		elif event is InputEventJoypadButton:
			if get_node("LevelsMenu/Menu").get_viewport().gui_get_focus_owner() == null:
				get_node("LevelsMenu/Menu/Panel/Back").grab_focus()
			if Input.get_joy_name(0) == "PS1 USB" or Input.get_joy_name(0) == "PS2 USB" or Input.get_joy_name(0) == "PS3 DualShock" or Input.get_joy_name(0) == "PS3 Controller" or Input.get_joy_name(0) == "PS4 Controller" or Input.get_joy_name(0) == "PS3 Controller (Bluetooth)" or Input.get_joy_name(0) == "PS4 Controller (Bluetooth)":
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				get_node("LevelsMenu/Menu/XinputControllerHint").hide()
				get_node("LevelsMenu/Menu/DinputControllerHint").show()
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
				get_node("LevelsMenu/Menu/XinputControllerHint").show()
				get_node("LevelsMenu/Menu/DinputControllerHint").hide()

func _on_MusicVolume_value_changed(value):
	MusicVolume = value

func _on_SoundVolume_value_changed(value):
	SoundVolume = value

func _on_Settings_pressed() -> void:
	get_node("LevelsMenu/Menu/Panel").hide()
	get_node("LevelsMenu/Menu/SettingsPanel").show()

func _on_back_from_settings_pressed() -> void:
	save_config()
	get_node("LevelsMenu/Menu/Panel").show()
	get_node("LevelsMenu/Menu/SettingsPanel").hide()
