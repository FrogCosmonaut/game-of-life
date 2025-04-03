class_name Grid
extends Node2D

signal running_toggled(value)
signal cicle_advanced(value)

@export_range(3, 64, 1) var grid_size: int = 16:
	set(value):
		grid_size = clampi(value, 3, 64)

@export_range(1.0, 100.0, 0.5) var simulation_speed: float = 1.0:
	set(value):
		simulation_speed = clampf(value, 1.0, 100.0)

@onready var camera: Camera2D = $Camera
@onready var tile_map: TileMapLayer = %TileMap

var tile_size: int
var cells: Dictionary[Vector2i, Cell] = {}
var running: bool = false:
	set(value):
		running = value
		running_toggled.emit(value)
var cicle_count: int = 0:
	set(value): 
		cicle_count = value
		cicle_advanced.emit(value)

func _ready() -> void:
	randomize()
	tile_size = tile_map.tile_set.tile_size.x
	tile_map.clear()
	_create_cells()
	_initialize_state()
	_draw_grid()
	_simulation_loop()


func _create_cells() -> void:
	for x in range(grid_size):
		for y in range(grid_size):
			var coords = Vector2i(x, y)
			cells[coords] = Cell.new(coords, self)


func _clear_cells() -> void:
	cells.clear()
	_create_cells()
	_draw_grid()


func _initialize_state(random: bool = false) -> void:
	for cell in cells.values():
		if random:
			cell.level = 0 if randf() < 0.3 else 0  # 30% chance for a cell to be alive
		else:
			cell.level = 0
		cell.next_level = cell.level


func _draw_grid() -> void:
	for cell in cells.values():
		cell.draw()


func _simulation_step() -> void:
	var all_dead: bool = true
	cicle_count += 1

	for cell in cells.values():
		cell.calculate_next_state()
		if cell.is_alive():
			all_dead = false

	for cell in cells.values():
		cell.update_state()

	if all_dead:
		_simulation_reset()
	_draw_grid()


func _simulation_loop() -> void:
	cicle_count = 0

	while running:
		await get_tree().create_timer(1.0 / simulation_speed).timeout
		_simulation_step()


func _simulation_reset() -> void:
	set_running(false)
	_clear_cells()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = tile_map.get_local_mouse_position()
		var cell_coords = tile_map.local_to_map(mouse_pos)
		if cell_coords.x >= 0 and cell_coords.x < grid_size and cell_coords.y >= 0 and cell_coords.y < grid_size:
			if cells.has(cell_coords):
				cells[cell_coords].level = 1 if cells[cell_coords].level == 0 else 0
				cells[cell_coords].next_level = cells[cell_coords].level
				cells[cell_coords].draw()


func _on_play_button_toggled(toggled_on: bool) -> void:
	set_running(toggled_on)


func _on_reset_button_pressed() -> void:
	_simulation_reset()


func _on_speed_slider_value_changed(value: float) -> void:
	simulation_speed = value


func set_running(value: bool) -> void:
	running = value
	if running:
		_simulation_loop()


func get_tile_map() -> TileMapLayer:
	return tile_map

func get_cells() -> Dictionary[Vector2i, Cell]:
	return cells

func get_grid_size() -> int:
	return grid_size
