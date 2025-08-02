extends ColorRect

@onready var MASTER_BUS_ID = AudioServer.get_bus_index("Master")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("BGM")

var masterBool = false
var bgmBool = false
var sfxBool = false

func _ready() -> void:
	$settings/mvol.value = db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS_ID))
	$settings/musvol.value = db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS_ID))
	$settings/sfxvol.value = db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS_ID))
	print($settings/mvol.value)
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$settings/fsc.set_pressed_no_signal(true)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		$settings/fsc.set_pressed_no_signal(false)


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
	
