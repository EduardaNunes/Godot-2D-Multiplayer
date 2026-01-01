extends Node

signal host_started()

const IP_ADRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS = 4 # Default = 32

var peer: ENetMultiplayerPeer

var players = {}
var player_info = {"name": "Name"}
var players_loaded = 0

# ---------------------------------------------------------------------------- #

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	host_started.emit()
	
# ---------------------------------------------------------------------------- #

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADRESS, PORT)
	multiplayer.multiplayer_peer = peer

# ---------------------------------------------------------------------------- #
