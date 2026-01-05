extends Node2D

# exported to sync
@export var game_started : bool = false
@export var current_countdown : int = COUNTDOWN_TIME
@export var lobby_status_text : String

@onready var player_spawner : MultiplayerSpawner = $MultiplayerSpawner

@onready var timer : Timer = $Timer
@onready var timer_label : Label = $CanvasLayer/VBoxContainer/Time_To_Start
@onready var timer_text_label : Label = $CanvasLayer/VBoxContainer/Label

var players_alive : Array[String] = []

const MIN_PLAYERS_TO_START = 2
const MAX_PLAYERS = 4
const COUNTDOWN_TIME = 15

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	if multiplayer.is_server():
		timer.timeout.connect(_on_server_timer_tick)
		update_lobby_ui("Aguardando Jogadores...", "")

# ---------------------------------------------------------------------------- #

# Called by player spawner
func register_player(connected_player_node):
	if not multiplayer.is_server(): return
	
	players_alive.append(connected_player_node.color)
	
	if not connected_player_node.player_died.is_connected(_on_player_died):
		connected_player_node.player_died.connect(_on_player_died.bind(connected_player_node.color))
	
	check_lobby_status()

# ---------------------------------------------------------------------------- #

# Called by player spawner
func unregister_player(disconnected_player_color):
	if disconnected_player_color in players_alive:
		players_alive.erase(disconnected_player_color)
		check_win_condition()
		check_lobby_status()

# ---------------------------------------------------------------------------- #

func check_lobby_status():
	if game_started: return
	
	var player_count = players_alive.size()
	
	# Case 1: lobby is full
	if player_count >= MAX_PLAYERS:
		timer.stop()
		start_game()
		return

	# Case 2: lobby has minimum players -> start timer
	if player_count >= MIN_PLAYERS_TO_START:
		if timer.is_stopped():
			current_countdown = COUNTDOWN_TIME
			timer.start()
			update_lobby_ui("O jogo vai inicar em: ", str(current_countdown))
	
	# Case 3: lobby dont have enougth players anymore -> cancel timer
	else:
		if not timer.is_stopped():
			timer.stop()
			update_lobby_ui("Aguardando Jogadores...", "")

# ---------------------------------------------------------------------------- #

func _on_server_timer_tick():
	current_countdown -= 1
	update_lobby_ui("O jogo vai iniciar em: ", str(current_countdown))
	
	if current_countdown <= 0:
		timer.stop()
		start_game()

# ---------------------------------------------------------------------------- #
		
func start_game():
	game_started = true
	timer_label.visible = false
	timer_text_label.visible = false

# ---------------------------------------------------------------------------- #

func update_lobby_ui(text_to_show: String, timer_countdown: String):
	timer_text_label.text = text_to_show
	timer_label.text = timer_countdown
	timer_text_label.visible = true
	timer_label.visible = true

# ---------------------------------------------------------------------------- #

func _on_player_died(dead_player_color):
	if dead_player_color in players_alive:
		players_alive.erase(dead_player_color)
		check_win_condition()
	
# ---------------------------------------------------------------------------- #

func check_win_condition():
	
	if not game_started: return
	
	if players_alive.size() == 1:
		var winner_color = players_alive[0]
		broadcast_game_over.rpc(winner_color)
		
	elif players_alive.size() == 0:
		print("Empate! Ninguém sobrou.")
		broadcast_game_over.rpc(null)
		
# ---------------------------------------------------------------------------- #

@rpc("authority", "call_local", "reliable")
func broadcast_game_over(winner_color: String):
	HighLevelNetworkHandler.game_over.emit(winner_color)
		
# ---------------------------------------------------------------------------- #
