extends Node

signal player_trow_snowball(position, rotation, id)

const MENU_SCENE_PATH : String = "res://High_Level_Multiplayer/Scenes/Menu.tscn"

const IP_ADRESS: String = "localhost"
const PORT: int = 42069
const MAX_CLIENTS = 3 # Default = 32

var peer: ENetMultiplayerPeer

func _ready() -> void:
	multiplayer.server_disconnected.connect(on_server_disconnected)

# ---------------------------------------------------------------------------- #

func start_server() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT, MAX_CLIENTS)
	multiplayer.multiplayer_peer = peer
	
# ---------------------------------------------------------------------------- #

func start_client() -> void:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_ADRESS, PORT)
	multiplayer.multiplayer_peer = peer

# ---------------------------------------------------------------------------- #

func on_server_disconnected() -> void:
	print("Disconectado do servidor. Voltando ao menu...")
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file(MENU_SCENE_PATH)
	
# ---------------------------------------------------------------------------- #
