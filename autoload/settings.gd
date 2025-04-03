extends Node

const SAVE_PATH = "user://settings.cfg"


var music_volume: float = 100.0:
	set(value):
		music_volume = clampf(value, 0.0, 1.0)
		var bus_idx = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_linear(bus_idx, music_volume)

var sound_volume: float = 100.0:
	set(value):
		sound_volume = clampf(value, 0.0, 1.0)
		var bus_idx = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_linear(bus_idx, sound_volume)

var htp_showed: bool = false

func _ready():
	load_settings()


func load_settings():
	var config = ConfigFile.new()
	var error = config.load(SAVE_PATH)
	
	if error != OK:
		print("No settings file found. Using defaults.")
		return

	music_volume = config.get_value("audio", "music_volume", music_volume)
	sound_volume = config.get_value("audio", "sound_volume", sound_volume)
	htp_showed = config.get_value("options", "htp_showed", htp_showed)


func save_settings():
	var config = ConfigFile.new()

	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sound_volume", sound_volume)
	config.set_value("options", "htp_showed", htp_showed)

	var error = config.save(SAVE_PATH)
	if error != OK:
		print("Failed to save settings. Error code: ", error)
