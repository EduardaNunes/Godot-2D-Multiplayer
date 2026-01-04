extends Node2D

signal game_over(winner_id)

# exported to sync
@export var game_started : bool = false
@onready var player_spawner : MultiplayerSpawner = $MultiplayerSpawner

var players_alive : Array[int] = []

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	pass

# ---------------------------------------------------------------------------- #

# Called by player spawner
func register_player(connected_player_node):
	if not multiplayer.is_server(): return
	
	var id = connected_player_node.name.to_int()
	players_alive.append(id)
	
	if not connected_player_node.player_died.is_connected(_on_player_died):
		connected_player_node.player_died.connect(_on_player_died.bind(id))
	
	if players_alive.size() >= 2: start_game()

# ---------------------------------------------------------------------------- #

# Called by player spawner
func unregister_player(disconnected_player_id):
	if disconnected_player_id in players_alive:
		players_alive.erase(disconnected_player_id)
		check_win_condition()

# ---------------------------------------------------------------------------- #

func _on_player_died(dead_player_id):
	if dead_player_id in players_alive:
		players_alive.erase(dead_player_id)
		check_win_condition()

# ---------------------------------------------------------------------------- #

func start_game() -> void:
	game_started = true
	pass
	
# ---------------------------------------------------------------------------- #

func check_win_condition():
	
	if not game_started: return
	
	if players_alive.size() == 1:
		var winner_id = players_alive[0]
		print("Temos um vencedor! ID: ", winner_id)
		game_over.emit(winner_id)
		
	elif players_alive.size() == 0:
		print("Empate! Ninguém sobrou.")
		
# ---------------------------------------------------------------------------- #
