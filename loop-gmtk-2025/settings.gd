extends ColorRect

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("BGM")

var masterBool = false
var bgmBool = false
var sfxBool = false

func _ready() -> void:
	Transition.playback("white_fade")
	$settings/quit.show()
	$settings/resume.show()
	$settings/mvol.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS_ID))
	$settings/musvol.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	$settings/sfxvol.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	print($settings/mvol.value)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$settings/fsc.set_pressed_no_signal(true)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		$settings/fsc.set_pressed_no_signal(false)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") && get_tree().current_scene.name == "driving":
		self.show()
		get_tree().paused = true
	elif get_tree().current_scene.name == "titel":
		$settings/quit.hide()
		$settings/resume.hide()


func _on_fsc_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_mvol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MASTER_BUS_ID, linear_to_db(value))
	if self.visible:
		$sfx.play()


func _on_sfxvol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	if self.visible:
		$sfx.play()


func _on_musvol_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	


func _on_resume_pressed() -> void:
	self.hide()
	get_tree().paused = false


func _on_quit_pressed() -> void:
	Transition.play("white_fade")
	get_tree().paused = false
	self.hide()
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file("res://titel.tscn")
