extends AudioStreamPlayer2D

@onready var player : CharacterBody2D = $".."

const SOUND_TROW = preload("res://High_Level_Multiplayer/Assets/Sounds/shoot1.wav")
const SOUND_HURT = preload("res://High_Level_Multiplayer/Assets/Sounds/SFX Error.wav")
const SOUND_DEATH = preload("res://High_Level_Multiplayer/Assets/Sounds/explode04.wav")

func _ready() -> void:
	HighLevelNetworkHandler.player_trow_snowball.connect(func(a,b,c): play_trow_sound())
	player.took_damage.connect(func(a): play_hurt_sound())
	player.player_died.connect(func(): play_death_sound())
	
func play_trow_sound():
	stream = SOUND_TROW
	play()

func play_hurt_sound():
	stream = SOUND_HURT
	play()
	
func play_death_sound():
	stream = SOUND_HURT
	play()
