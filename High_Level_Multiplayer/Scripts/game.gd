extends Node2D

# exported to sync
@export var game_started : bool = false
@onready var player_spawner : MultiplayerSpawner = $MultiplayerSpawner

var players_alive : Array[String] = []

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	pass

# ---------------------------------------------------------------------------- #

# Called by player spawner
func register_player(connected_player_node):
	if not multiplayer.is_server(): return
	
	players_alive.append(connected_player_node.color)
	
	if not connected_player_node.player_died.is_connected(_on_player_died):
		connected_player_node.player_died.connect(_on_player_died.bind(connected_player_node.color))
	
	if players_alive.size() >= 2: start_game()

# ---------------------------------------------------------------------------- #

# Called by player spawner
func unregister_player(disconnected_player_color):
	if disconnected_player_color in players_alive:
		players_alive.erase(disconnected_player_color)
		check_win_condition()

# ---------------------------------------------------------------------------- #

func _on_player_died(dead_player_color):
	if dead_player_color in players_alive:
		players_alive.erase(dead_player_color)
		check_win_condition()

# ---------------------------------------------------------------------------- #

func start_game() -> void:
	game_started = true
	pass
	
# ---------------------------------------------------------------------------- #

func check_win_condition():
	
	if not game_started: return
	
	if players_alive.size() == 1:
		var winner_color = players_alive[0]
		broadcast_game_over.rpc(winner_color)
		finish_game()
		
	elif players_alive.size() == 0:
		print("Empate! Ninguém sobrou.")
		broadcast_game_over.rpc(null)
		
@rpc("authority", "call_local", "reliable")
func broadcast_game_over(winner_color: String):
	HighLevelNetworkHandler.game_over.emit(winner_color)
		
# ---------------------------------------------------------------------------- #



func finish_game() -> void:
	pass
