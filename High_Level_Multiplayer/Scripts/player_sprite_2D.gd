# ---------------------------------------------------------------------------- #

extends Sprite2D

@onready var player : CharacterBody2D = $".."

const TEXTURE_BLUE = preload("res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_blue.png")
const TEXTURE_GREEN = preload("res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_green.png")
const TEXTURE_RED = preload("res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_red.png")
const TEXTURE_YELLOW = preload("res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_yellow.png")

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	load_texture_by_player_color()

# ---------------------------------------------------------------------------- #
		
func load_texture_by_player_color() -> void:
	
	match (player.color):
		'blue': texture = TEXTURE_BLUE
		'green': texture = TEXTURE_GREEN
		'yellow': texture = TEXTURE_YELLOW
		'red': texture = TEXTURE_RED
		_: print('Erro ao atualizar cor do sprite do jogador')
			
# ---------------------------------------------------------------------------- #
