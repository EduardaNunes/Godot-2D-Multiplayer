
# ---------------------------------------------------------------------------- #

extends Control
@export var gameScene : PackedScene
@export var tutorialScene : PackedScene
@export var CreditsScene : PackedScene
@export var menuButtons : Array[Button]

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	toggle_buttons('enable')

# ---------------------------------------------------------------------------- #

func _on_host_pressed() -> void:
	
	toggle_buttons('disable')
	HighLevelNetworkHandler.start_server()
	get_tree().change_scene_to_packed(gameScene)

# ---------------------------------------------------------------------------- #

func _on_client_pressed() -> void:
	toggle_buttons('disable')
	HighLevelNetworkHandler.start_client()
	get_tree().change_scene_to_packed(gameScene)

# ---------------------------------------------------------------------------- #

func _on_tutorial_pressed() -> void:
	toggle_buttons('disable')
	get_tree().change_scene_to_packed(tutorialScene)

# ---------------------------------------------------------------------------- #

func _on_credits_pressed() -> void:
	toggle_buttons('disable')
	get_tree().change_scene_to_packed(CreditsScene)

# ---------------------------------------------------------------------------- #

func _on_exit_pressed() -> void:
	toggle_buttons('disable')
	get_tree().quit()
	
# ---------------------------------------------------------------------------- #

func toggle_buttons(operation):
	
	if operation == 'disable' :
		operation = true
	elif operation == 'enable':
		operation = false
	else:
		print('operação inválida. Esperado: disable ou enable. Recebido: ', operation)
		return
		
	for button in menuButtons:
		button.disabled = operation

# ---------------------------------------------------------------------------- #
