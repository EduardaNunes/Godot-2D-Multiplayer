extends MultiplayerSpawner

@export var playerScene : PackedScene

var connected_players : int = 0
var colors = ['green', 'blue', 'yellow', 'red']

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	
	spawn_function = spawn_player
	
	if multiplayer.is_server():
		
		spawn.call_deferred(1) # 1 is always the host id
		connected_players += 1
		# peer connected and disconnected alredy pass the multiplayer id to the calling function
		multiplayer.peer_connected.connect(spawn)
		multiplayer.peer_disconnected.connect(remove_player)
		
# ---------------------------------------------------------------------------- #

func spawn_player(id):
	
	var player = playerScene.instantiate()
	player.color = colors[connected_players]
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
