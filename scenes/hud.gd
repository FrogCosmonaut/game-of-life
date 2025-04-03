class_name HUD
extends CanvasLayer

const HOWTOPLAY_POPUP = preload("res://scenes/popups/howtoplay_popup.tscn")

@onready var start_button: Button = %StartButton
@onready var reset_button: Button = %ResetButton
@onready var speed_slider: HSlider = %SpeedSlider
@onready var cicle_label: Label = %CicleLabel
@onready var speed_label: Label = %SpeedLabel


func _on_grid_running_toggled(value: Variant) -> void:
	if value:
		start_button.text = "STOP"
	else:
		start_button.text = "START"
	start_button.button_pressed = value


func _on_grid_cicle_advanced(value: Variant) -> void:
	cicle_label.text = "Cicle: %s" % value


func _on_htp_button_pressed() -> void:
	add_child(HOWTOPLAY_POPUP.instantiate())


func _on_speed_slider_value_changed(value: float) -> void:
	speed_label.text = "Sim Speed: x%s" % int(value) 
