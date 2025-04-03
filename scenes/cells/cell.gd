class_name Cell
extends RefCounted

const SOURCE_ID: int = 0

var level: int = 0
var next_level: int = 0

# init variables
var coords: Vector2i

# grid data
var tile_map: TileMapLayer
var cells: Dictionary[Vector2i, Cell]
var grid_size: int


func _init(_coords: Vector2i, grid: Grid) -> void:
	coords = _coords
	tile_map = grid.get_tile_map()
	cells = grid.get_cells()
	grid_size = grid.get_grid_size()


func draw() -> void:
	tile_map.set_cell(coords, SOURCE_ID, Vector2i(level, 0))


func is_alive() -> bool:
	return level != 0


func calculate_next_state() -> void:
	var neighbor_count: int = 0
	
	# Count neighbors
	for x in range(-1, 2):
		for y in range(-1, 2):
			if x == 0 and y == 0:
				continue  # Skip the cell itself
				
			var neighbor_coords = Vector2i(
				(coords.x + x + grid_size) % grid_size,
				(coords.y + y + grid_size) % grid_size
			)
			
			var neighbor = cells.get(neighbor_coords)
			if neighbor and neighbor.level > 0:
				neighbor_count += 1
	
	# Apply Conway's Game of Life rules
	if self.level > 0:
		# Cell is alive
		if neighbor_count < 2 or neighbor_count > 3:
			self.next_level = 0  # Cell dies
		else:
			self.next_level = 1  # Cell survives
	else:
		# Cell is dead
		if neighbor_count == 3:
			self.next_level = 1  # Cell becomes alive
		else:
			self.next_level = 0  # Cell stays dead


func update_state() -> void:
	self.level = self.next_level
