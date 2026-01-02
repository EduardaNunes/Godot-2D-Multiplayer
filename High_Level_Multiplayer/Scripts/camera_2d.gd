extends Camera2D

var tilemap : TileMapLayer

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	
	# confirms map is loaded on game scene
	await get_tree().process_frame
	
	set_tilemap()
	setup_camera_limits()

# ---------------------------------------------------------------------------- #

func set_tilemap():
	var maps = get_tree().get_nodes_in_group("camera_limits")
	
	if maps.size() > 0:
		tilemap = maps[0]
		print('O mapa "', tilemap.name ,'" foi encontrado no grupo "camera_limits"')
		
	else:
		print('Nenhum mapa encontrado no grupo "camera_limits"')
# ---------------------------------------------------------------------------- #

func setup_camera_limits():
	
	if not tilemap: return
	
	var rect : Rect2i = tilemap.get_used_rect()
	var tile_size = tilemap.tile_set.get_tile_size()
	var map_pos = tilemap.global_position
	
	limit_left = map_pos.x + (rect.position.x * tile_size.x)
	limit_right = limit_left + (rect.size.x * tile_size.x)
	limit_top = map_pos.y + (rect.position.y * tile_size.y)
	limit_bottom = limit_top + (rect.size.y * tile_size.y)
	
# ---------------------------------------------------------------------------- #
