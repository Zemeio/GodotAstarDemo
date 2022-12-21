class_name CustomTileMap
extends TileMap

onready var cursor = $Cursor
onready var selected_cell := Vector2(3,3)


var astar := AStar2D.new()

# Used to record the ID used in AStar (which can be an UUID or a sequential number)
var astarid = {}

func _ready(): 
	cursor.global_position = map_to_world(selected_cell)
	setup_astar()


func _process(delta):
	var dest = Vector2(selected_cell)
	if Input.is_action_just_pressed("ui_right"):
		dest.x += 1
	if Input.is_action_just_pressed("ui_left"):
		dest.x -= 1
	if Input.is_action_just_pressed("ui_down"):
		dest.y += 1
	if Input.is_action_just_pressed("ui_up"):
		dest.y -= 1
	var type = get_cell(dest.x, dest.y)
	if walkable(dest):
		selected_cell = dest
	cursor.global_position = map_to_world(selected_cell)

func walkable(pos) -> bool:
	# Walkable if cell is used and does not have a collision
	var type = get_cell(pos.x, pos.y)
	return type != -1 and not get_collision_mask_bit(type)

func setup_astar():
	astar = AStar2D.new()
	var id = 0
	# Populate the points in AStar by adding each used cell to it
	for point in self.get_used_cells():
		if walkable(point):
			astar.add_point(id, point)
			astarid[point] = id 
			id += 1

	# Add neighbors to astar, picking the directly connected cells that are walkable
	for point in astar.get_points():
		var coord = astar.get_point_position(point)
		var neighbors = get_neighbors(coord)
		for neighbor in neighbors:
			if walkable(neighbor):
				if neighbor in astarid:
					astar.connect_points(point, astarid[neighbor])
				else:
					printerr("Trying to connect to non-existing point")
					continue

func get_neighbors(pos: Vector2):
	return [
		Vector2(pos) + Vector2(0,1),
		Vector2(pos) + Vector2(1,0),
		Vector2(pos) + Vector2(-1,0),
		Vector2(pos) + Vector2(0,-1),
	]
