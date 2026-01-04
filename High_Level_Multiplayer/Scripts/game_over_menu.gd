# ---------------------------------------------------------------------------- #

extends Control

@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var winner_label : Label = $Panel/Container/VBoxContainer/VBoxContainer2/Winner_Label

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	self.visible = false
	HighLevelNetworkHandler.game_over.connect(show_gameover_menu)

# ---------------------------------------------------------------------------- #

func _on_exit_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file(HighLevelNetworkHandler.MENU_SCENE_PATH)

# ---------------------------------------------------------------------------- #

func show_gameover_menu(winner_color) -> void:
	winner_label.text = str('O jogador ', winner_color, ' ganhou!')
	self.visible = true
	
# ---------------------------------------------------------------------------- #
