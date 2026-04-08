extends Control

var BTC_WALLET = "bc1q6jp0g9jhrcx5l75gyg4c698yvg5qtm08j826p5"
var ETH_WALLET = "0x7b3E49fd98D64E965a4F26F67C236Dc80C31766D"
var XMR_WALLET = "87Yt5dCNEoEb3WhpfgjUhGFSJMgPaPhb65jMaDLLoyZ4DEBFx62AGzYVii3tzEfqBz8c3HXJ8QyjM9KASh1iRoqpPLAdN7r"

var REPO_URL = "https://github.com/yepgoryo/EggReturnsHome"

var PrevButton = ""

var CurrentPanel

var LastPanel = 1

var Controller = false

var levelToLoad

func _ready():
	set_process_input(true)
	get_node("SettingsPanel/MusicScroll").set_value(float(get_node("/root/AutoLoad").MusicVolume))
	get_node("SettingsPanel/SoundScroll").set_value(float(get_node("/root/AutoLoad").SoundVolume))
	for i in range(1, 41):
		var isLevelOpened = (((i - 2) < get_node("/root/AutoLoad").Data_Levels or get_node("/root/AutoLoad").Data_Levels == 0 and i == 1) and i != 30 and i != 40)
		var isLevelReached = ((i - 2) < get_node("/root/AutoLoad").Data_Levels or get_node("/root/AutoLoad").Data_Levels == 0 and i == 1)
		var differentTextTheme = load("res://Themes/LevelButtonTextThemeDifferent.tres")
		if i <= 10:
			if (i == 6 or i == 10) and isLevelReached:
				get_node("Panel1/LevelButtons/Level" + str(i) + "/LevelButton").set_theme(differentTextTheme)
				get_node("Panel1/LevelButtons/Level" + str(i) + "/LevelButton").set_text("?!")
			if not isLevelOpened:
				get_node("Panel1/LevelButtons/Level" + str(i) + "/LevelButton").set_disabled(true)
		elif i > 10 and i <= 20:
			if i == 20 and isLevelReached:
				get_node("Panel2/LevelButtons/Level" + str(i - 10) + "/LevelButton").set_theme(differentTextTheme)
				get_node("Panel2/LevelButtons/Level" + str(i - 10) + "/LevelButton").set_text("?!")
			if not isLevelOpened:
				get_node("Panel2/LevelButtons/Level" + str(i - 10) + "/LevelButton").set_disabled(true)
		elif i > 20 and i <= 30:
			if i == 30 and isLevelReached:
				get_node("Panel3/LevelButtons/Level" + str(i - 20) + "/LevelButton").set_theme(differentTextTheme)
				get_node("Panel3/LevelButtons/Level" + str(i - 20) + "/LevelButton").set_text("?!")
			if not isLevelOpened:
				get_node("Panel3/LevelButtons/Level" + str(i - 20) + "/LevelButton").set_disabled(true)
		elif i > 30 and i <= 40:
			if i == 40 and isLevelReached:
				get_node("Panel4/LevelButtons/Level" + str(i - 30) + "/LevelButton").set_theme(differentTextTheme)
				get_node("Panel4/LevelButtons/Level" + str(i - 30) + "/LevelButton").set_text("?!")
			if not isLevelOpened:
				get_node("Panel4/LevelButtons/Level" + str(i - 30) + "/LevelButton").set_disabled(true)

func get_level_time_str(level):
	var level_timer = get_node("/root/AutoLoad").Data_LevelsScores[level]
	var levelTimerString = str(("%02d" % (int((level_timer / (1000 * 60 * 60)) % 24)))) + "." + str(("%02d" % (int((level_timer / (1000 * 60)) % 60)))) + "." + str(("%02d" % (int((level_timer / 1000) % 60)))) + "." + str(int(level_timer / 100 % 10))
	if level == 6 or level == 10 or level == 20:
		levelTimerString = "--"
	elif level == 30:
		levelTimerString = "@&#^$"
	elif level == 40:
		levelTimerString = "$^#&@"
	return levelTimerString

func _input(event):
	if event is InputEventMouseMotion:
		Controller = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_node("XinputControllerHint").hide()
		get_node("DinputControllerHint").hide()
		if get_viewport().gui_get_focus_owner() != null:
			get_viewport().gui_get_focus_owner().release_focus()
	elif event is InputEventJoypadButton:
		Controller = true
		if get_viewport().gui_get_focus_owner() == null:
			if PrevButton == "":
				get_node("MainMenu/MainMenuButtons").get_children()[0].grab_focus()
			elif PrevButton == "NewGame":
				get_node("ChooseDifficulty").get_children()[1].grab_focus()
			elif PrevButton == "Continue":
				if not get_node("Panel" + str(CurrentPanel)).get_children()[1].is_disabled():
					get_node("Panel" + str(CurrentPanel)).get_children()[1].grab_focus()
				else:
					if LastPanel > CurrentPanel:
						get_node("Panel" + str(CurrentPanel) + "/RightButton").grab_focus()
					else:
						get_node("Panel" + str(CurrentPanel) + "/LeftButton").grab_focus()
			elif PrevButton == "Settings":
				get_node("SettingsPanel/BackToMenu").grab_focus()
			elif PrevButton == "About":
				get_node("About").get_children()[4].grab_focus()
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		if Input.get_joy_name(0) == "PS1 USB" or Input.get_joy_name(0) == "PS2 USB" or Input.get_joy_name(0) == "PS3 DualShock" or Input.get_joy_name(0) == "PS3 Controller" or Input.get_joy_name(0) == "PS4 Controller" or Input.get_joy_name(0) == "PS3 Controller (Bluetooth)" or Input.get_joy_name(0) == "PS4 Controller (Bluetooth)":
			get_node("XinputControllerHint").hide()
			get_node("DinputControllerHint").show()
		else:
			get_node("XinputControllerHint").show()
			get_node("DinputControllerHint").hide()

func _on_NewGame_pressed():
	print("New game pressed")
	PrevButton = "NewGame"
	get_node("DarkScreen").show()
	get_node("ChooseDifficulty").show()
	MainMenu_disable()
	if Controller:
		get_node("ChooseDifficulty").get_children()[1].grab_focus()

func _on_Continue_pressed():
	PrevButton = "Continue"
	get_node("DarkScreen").show()
	get_node("Panel1").show()
	MainMenu_disable()
	CurrentPanel = 1
	LastPanel = 1
	if Controller:
		get_node("Panel1").get_children()[1].grab_focus()

func _on_Settings_pressed():
	PrevButton = "Settings"
	get_node("DarkScreen").show()
	get_node("SettingsPanel").show()
	MainMenu_disable()
	if Controller:
		get_node("SettingsPanel/BackToMenu").grab_focus()

func _on_MusicVolume_value_changed(value):
	get_node("/root/AutoLoad").MusicVolume = value

func _on_SoundVolume_value_changed(value):
	get_node("/root/AutoLoad").SoundVolume = value

func _on_About_pressed():
	PrevButton = "About"
	get_node("AnimationPlayer").play("switchToAbout")
	get_node("About").show()
	
	MainMenu_disable()
	if Controller:
		get_node("About").get_children()[4].grab_focus()

func _on_AboutBack_pressed():
	MainMenu_enable()
	get_node("AnimationPlayer").play("switchBackToMenu")

func _on_SwitchButton_pressed(panel):
	get_node("Panel1").hide()
	get_node("Panel2").hide()
	get_node("Panel3").hide()
	get_node("Panel4").hide()
	LastPanel = CurrentPanel
	CurrentPanel = panel
	get_node(("Panel" + str(panel))).show()
	if Controller:
		if LastPanel >= CurrentPanel:
			get_node("Panel" + str(panel) + "/RightButton").grab_focus()
		else:
			get_node("Panel" + str(panel) + "/LeftButton").grab_focus()

func _on_ChooseMode_pressed(hardmode):
	get_node("/root/AutoLoad").Data_LevelsScores = []
	for i in range(0, 41):
		get_node("/root/AutoLoad").Data_LevelsScores.append(0)
	get_node("/root/AutoLoad").Data_Levels = 0
	get_node("/root/AutoLoad").Data_HardMode = hardmode
	get_node("/root/AutoLoad").save_data()
	get_node("/root/AutoLoad").load_scene_start("res://Scenes/Beginning.tscn", true)

func _on_LoadLevel_pressed(level):
	levelToLoad = level
	
	get_node("Panel1").hide()
	get_node("Panel2").hide()
	get_node("Panel3").hide()
	get_node("Panel4").hide()
	
	if levelToLoad <= 10:
		get_node("LevelPlayScore/Background").set_texture(load("res://Sprites/LevelScreenshots/level1.png"))
	elif level > 10 and level <= 20:
		get_node("LevelPlayScore/Background").set_texture(load("res://Sprites/LevelScreenshots/level2.png"))
	elif level > 20 and level <= 30:
		get_node("LevelPlayScore/Background").set_texture(load("res://Sprites/LevelScreenshots/level3.png"))
	elif level > 30 and level <= 40:
		get_node("LevelPlayScore/Background").set_texture(load("res://Sprites/LevelScreenshots/level4.png"))
	
	get_node("LevelPlayScore").set_visible(true)
	get_node("LevelPlayScore/Head/HeadLabel").set_text("Level #" + str(levelToLoad))
	
	get_node("LevelPlayScore/LevelScoreTimeLabel").set_text(get_level_time_str(levelToLoad))

func back_from_score():
	get_node("LevelPlayScore").set_visible(false)
	_on_SwitchButton_pressed(CurrentPanel)

func load_level():
	if levelToLoad == 1 and get_node("/root/AutoLoad").Data_Levels == 0:
		_on_BackToMenu_pressed()
		_on_NewGame_pressed()
	else:
		get_node("/root/AutoLoad").load_scene_start("res://Scenes/lvl_" + str(levelToLoad) + ".tscn", true)

func _on_BackToMenu_pressed():
	get_node("DarkScreen").hide()
	get_node("ChooseDifficulty").hide()
	get_node("SettingsPanel").hide()
	get_node("About").hide()
	get_node("Panel1").hide()
	get_node("Panel2").hide()
	get_node("Panel3").hide()
	get_node("Panel4").hide()
	MainMenu_enable()
	if PrevButton == "Settings":
		get_node("/root/AutoLoad").save_config()
	if Controller:
		get_node(("MainMenu/MainMenuButtons/" + PrevButton)).grab_focus()
	PrevButton = ""

func MainMenu_disable():
	var MenuButtons = get_node("MainMenu/MainMenuButtons").get_children()
	for i in MenuButtons:
		i.release_focus()
		i.set_disabled(true)

func MainMenu_enable():
	var MenuButtons = get_node("MainMenu/MainMenuButtons").get_children()
	for i in MenuButtons:
		i.set_disabled(false)
	if Controller:
		get_node("MainMenu/MainMenuButtons").get_children()[0].grab_focus()

func _on_Quit_pressed():
	get_tree().quit()


func _on_btc_pressed() -> void:
	DisplayServer.clipboard_set(BTC_WALLET)
	get_node("Donate/AnimationPlayer").play("clipboard_copied")


func _on_eth_pressed() -> void:
	DisplayServer.clipboard_set(ETH_WALLET)
	get_node("Donate/AnimationPlayer").play("clipboard_copied")


func _on_xmr_pressed() -> void:
	DisplayServer.clipboard_set(XMR_WALLET)
	get_node("Donate/AnimationPlayer").play("clipboard_copied")

func _on_donate_pressed() -> void:
	get_node("/root/Main/Egg").Stopped = true
	get_node("DarkScreen").set_visible(true)
	get_node("About").set_visible(false)
	get_node("Donate").set_visible(true)

func back_from_donate() -> void:
	get_node("/root/Main/Egg").Stopped = false
	get_node("DarkScreen").set_visible(false)
	get_node("About").set_visible(true)
	get_node("Donate").set_visible(false)


func _on_repo_pressed() -> void:
	OS.shell_open(REPO_URL)


func _on_left_up_pressed() -> void:
	get_node("/root/AutoLoad")._on_left_up_pressed()


func _on_left_down_pressed() -> void:
	get_node("/root/AutoLoad")._on_left_down_pressed()


func _on_right_up_pressed() -> void:
	get_node("/root/AutoLoad")._on_right_up_pressed()


func _on_right_down_pressed() -> void:
	get_node("/root/AutoLoad")._on_right_down_pressed()
