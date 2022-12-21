extends Node2D

export (NodePath) var tilemap_path
export (bool) var draw_grid := true setget set_draw_grid
export (bool) var draw_astar := true setget set_draw_astar

onready var tilemap: CustomTileMap = get_node(tilemap_path) as CustomTileMap

func _ready():
	self.update()

func _draw_grid():
	for point in tilemap.get_used_cells():
		var pos = tilemap.map_to_world(point)
		var rect = Rect2(pos, Vector2(16, 16))
		var type = tilemap.get_cell(point.x, point.y)
		draw_rect(rect, Color.aqua, false, 1.5)
		var fill_color: Color
		match type:
			3:
				fill_color = Color.cadetblue
			0:
				fill_color = Color.purple
			_:
				print_debug(type)
		if tilemap.get_collision_mask_bit(type):
			fill_color = Color.red
		fill_color.a = 0.3
		draw_rect(rect, fill_color, true, 1)

func _draw_astar():
	var astar = tilemap.astar as AStar2D
	if not astar:
		return
	for point in astar.get_points():
		var coord = astar.get_point_position(point)
		var pos = tilemap.map_to_world(coord) + Vector2(6, 6)
		var rect = Rect2(pos, Vector2(4, 4))
		draw_rect(rect, Color.black, true)
		for connection in astar.get_point_connections(point):
			var dest = astar.get_point_position(connection)
			var dest_pos = tilemap.map_to_world(dest) + Vector2(8, 8)
			draw_line(pos, dest_pos, Color.white)

func _draw():
	if draw_grid:
		_draw_grid()
	if draw_astar:
		_draw_astar()

func set_draw_grid(value):
	draw_grid = value
	self.update()

func set_draw_astar(value):
	draw_astar = value
	self.update()

func _process(delta):
	if Input.is_action_just_pressed("DrawDebugGrid"):
		self.draw_grid = not self.draw_grid
	if Input.is_action_just_pressed("DrawDebugAstar"):
		self.draw_astar = not self.draw_astar
