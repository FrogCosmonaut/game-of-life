extends Camera2D

var drag_active = false
var last_mouse_position = Vector2.ZERO
var zoom_sensitivity = 0.1
var min_zoom = 0.25
var max_zoom = 2.5

# Boundaries
var grid_width = 0
var grid_height = 0
var boundary_margin = 100


func _ready():
	zoom = Vector2.ONE / 1.5
	position.x = get_viewport().size.x / 2
	position.y = get_viewport().size.y / 1.4  # I don't fucking know why lol


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom_camera(zoom_sensitivity, event.position)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom_camera(-zoom_sensitivity, event.position)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			if event.pressed:
				drag_active = true
				last_mouse_position = event.position
			else:
				drag_active = false

	if event is InputEventMouseMotion and drag_active:
		var delta = event.position - last_mouse_position
		position -= delta / zoom.x
		last_mouse_position = event.position
	
	if event.is_action("ui_accept"):
		print(zoom)
		print(position)


func _zoom_camera(zoom_factor, mouse_position) -> void:
	var viewport_size = get_viewport().size
	var prev_zoom = zoom.x
	zoom.x = clamp(zoom.x + zoom_factor, min_zoom, max_zoom)
	zoom.y = zoom.x
	position += Vector2((viewport_size / 2.0) - mouse_position) * (1.0 / prev_zoom - 1.0 / zoom.x)
