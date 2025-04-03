extends Control


func _on_close_button_pressed() -> void:
	call_deferred("queue_free")
