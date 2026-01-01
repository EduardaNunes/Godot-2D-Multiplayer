extends MultiplayerSpawner

@export var playerScene : PackedScene

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	
	spawn_function = spawn_player
	
	if multiplayer.is_server():
		spawn.call_deferred(1) # 1 is always the host id
		# peer connected and disconnected alredy pass the multiplayer id to the calling function
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)
		
# ---------------------------------------------------------------------------- #

func spawn_player(id):
	
	var player = playerScene.instantiate()
	player.position = $"../Spawner".position
	player.name = str(id)
	player.set_multiplayer_authority(id)
	# When we return the object the spawn_function adds it to the node parent (spawn path)
	return player 
	
# ---------------------------------------------------------------------------- #

func remove_player(id):
	if get_node(spawn_path).has_node(str(id)):
		get_node(spawn_path).get_node(str(id)).queue_free()
		
# ---------------------------------------------------------------------------- #
"""
func spawn_player(id: int) -> void:
	
	# Only runs by the server
	if not multiplayer.is_server(): return
	
	var player : Node = playerScene.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player) # add to the parent node
"""
# ---------------------------------------------------------------------------- #
"""
func remove_player(id: int) -> void:
	
	# Only runs by the server
	if not multiplayer.is_server(): return
		
	var path_node = get_node(spawn_path)
	if path_node.has_node(str(id)):
		path_node.get_node(str(id)).queue_free()
"""
# ---------------------------------------------------------------------------- #
