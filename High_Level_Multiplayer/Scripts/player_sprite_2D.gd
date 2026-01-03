# ---------------------------------------------------------------------------- #

extends Sprite2D

@onready var player : CharacterBody2D = $".."
@onready var player_blue = "res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_blue.png" 
@onready var player_green = "res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_green.png"
@onready var player_red = "res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_red.png"
@onready var player_yellow = "res://High_Level_Multiplayer/Assets/Sprites/players/spritesheet_yellow.png" 

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	load_texture_by_player_color()

# ---------------------------------------------------------------------------- #
		
func load_texture_by_player_color() -> void:
	
	match (player.color):
		'blue':
			texture = load(player_blue)
			pass
		'green':
			texture = load(player_green)
			pass
		'yellow':
			texture = load(player_yellow)
			pass
		'red':
			texture = load(player_red)
			pass
		_:
			print('Erro ao atualizar cor do sprite do jogador')
			
# ---------------------------------------------------------------------------- #
