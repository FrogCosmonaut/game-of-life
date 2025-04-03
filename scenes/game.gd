extends Control


const HOWTOPLAY_POPUP = preload("res://scenes/popups/howtoplay_popup.tscn")


func _ready() -> void:
	if not Settings.htp_showed:
		add_child(HOWTOPLAY_POPUP.instantiate())
		Settings.htp_showed = true
		Settings.save_settings()
