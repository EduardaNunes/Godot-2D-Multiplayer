extends MultiplayerSpawner

@export var snowball_scene : PackedScene
@onready var game_controller : Node2D = $"../.."

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	spawn_function = trow
	HighLevelNetworkHandler.player_trow_snowball.connect(handle_trow)
		
# ---------------------------------------------------------------------------- #

func trow(data):
	
	var snowball = snowball_scene.instantiate()
	
	snowball.global_position = data.position
	snowball.global_rotation = data.rotation
	snowball.velocity = Vector2.RIGHT.rotated(data.rotation)
	snowball.shooter_id = data.id
	
	# When we return the object the spawn_function adds it to the node parent (spawn path)
	return snowball

# ---------------------------------------------------------------------------- #

func handle_trow(player_position, aim_rotation, player_id):
	
	if not game_controller.game_started: return
	
	if multiplayer.is_server():
		var data = {
			"position": player_position,
			"rotation": aim_rotation,
			"id": player_id
		}
		spawn(data)
	else:
		request_trow_to_server.rpc_id(1, player_position, aim_rotation, player_id)

# ---------------------------------------------------------------------------- #

@rpc("any_peer", "call_remote")
func request_trow_to_server(client_player_position, client_aim_rotation, client_player_id):

	var data = {
		"position": client_player_position,
		"rotation": client_aim_rotation,
		"id": client_player_id
	}
	spawn(data)

# ---------------------------------------------------------------------------- #
