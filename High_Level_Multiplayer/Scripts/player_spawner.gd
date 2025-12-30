extends MultiplayerSpawner

@export var playerScene : PackedScene

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	multiplayer.peer_connected.connect(spawn_player)
	#HighLevelNetworkHandler.host_started.connect(spawn_host_player)

# ---------------------------------------------------------------------------- #
	
func spawn_player(id: int) -> void:
	# Execute Server Only
	if multiplayer.is_server():
		var player : Node = playerScene.instantiate()
		player.name = str(id)
		get_node(spawn_path).call_deferred("add_child", player)

# ---------------------------------------------------------------------------- #

func spawn_host_player() -> void:
	# Execute Server Only
	if not multiplayer.is_server(): return
	spawn_player(multiplayer.get_unique_id())

# ---------------------------------------------------------------------------- #
