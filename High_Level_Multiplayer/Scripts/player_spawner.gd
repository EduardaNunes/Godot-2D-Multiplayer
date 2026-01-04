extends MultiplayerSpawner

@export var playerScene : PackedScene
@onready var game_controller : Node2D = $".."

var spawned_players : int = 0
var colors = ['green', 'blue', 'yellow', 'red']

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	
	spawn_function = spawn_player
	
	if multiplayer.is_server():
		handle_spawn_data(1) # 1 is always the host id
		# peer connected and disconnected alredy pass the multiplayer id to the calling function
		multiplayer.peer_connected.connect(handle_spawn_data)
		multiplayer.peer_disconnected.connect(remove_player)
		
# ---------------------------------------------------------------------------- #

func handle_spawn_data(id):
	
	var color = colors[spawned_players]
	
	var data = {"id": id, "color": color}
	
	spawn.call_deferred(data)
	spawned_players += 1

func spawn_player(data):
	
	var player = playerScene.instantiate()
	player.color = data.color
	player.position = $"../Spawner".position
	player.name = str(data.id)
	player.set_multiplayer_authority(data.id)
	
	if multiplayer.is_server():
		game_controller.register_player.call_deferred(player)
	
	# When we return the object the spawn_function adds it to the node parent (spawn path)
	return player 
	
# ---------------------------------------------------------------------------- #

func remove_player(id):
	if get_node(spawn_path).has_node(str(id)):
		get_node(spawn_path).get_node(str(id)).queue_free()
	
	if multiplayer.is_server(): 
		spawned_players -= 1
		game_controller.unregister_player(id)
		
# ---------------------------------------------------------------------------- #
