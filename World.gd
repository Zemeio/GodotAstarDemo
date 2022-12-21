extends Node2D

onready var tilemap = $TileMap as CustomTileMap
onready var sprite = $Sprite

enum {
	MOVING,
	STATIC
}

var status = STATIC setget set_status
var path: Array = []

func _process(delta):
	match status:
		STATIC:
			sprite.visible = false
			if Input.is_action_just_pressed("select"):
				var dest = get_global_mouse_position()
				var coord = tilemap.world_to_map(dest)
				var pos = tilemap.selected_cell
				if tilemap.walkable(coord):
					var path_grid = tilemap.astar.get_point_path(tilemap.astarid[pos], tilemap.astarid[coord])
					path.clear()
					for node in path_grid:
						var center = tilemap.map_to_world(node)
						path.append(center)
					sprite.global_position = tilemap.map_to_world(tilemap.selected_cell)
					move()

func move():
	if path.size() > 0:
		status = MOVING
		sprite.visible = true
		var tween = get_tree().create_tween()
		for pos in path:
			tween.tween_property(sprite, "global_position", pos, 0.1)
		tween.connect("finished", self, "set_status", [STATIC])

func set_status(value):
	status = value
