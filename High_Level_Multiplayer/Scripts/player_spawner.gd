extends MultiplayerSpawner

@export var playerScene : PackedScene

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	if multiplayer.is_server():
		spawn_player(1) # 1 is always the host id

# ---------------------------------------------------------------------------- #
	
func spawn_player(id: int) -> void:
	
	if not multiplayer.is_server(): return
	
	var player : Node = playerScene.instantiate()
	player.name = str(id)
	get_node(spawn_path).call_deferred("add_child", player) # add to the parent node

# ---------------------------------------------------------------------------- #

func remove_player(id: int) -> void:
	
	if not multiplayer.is_server(): return
		
	var path_node = get_node(spawn_path)
	if path_node.has_node(str(id)):
		path_node.get_node(str(id)).queue_free()
		
# ---------------------------------------------------------------------------- #
