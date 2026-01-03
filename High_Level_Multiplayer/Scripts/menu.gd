
# ---------------------------------------------------------------------------- #

extends Control
@export var gameScene : PackedScene
@export var tutorialScene : PackedScene
@export var CreditsScene : PackedScene
@export var menuButtons : Array[Button]

@onready var errorPanel : Panel = $Error
@onready var errorLabel : Label = $Error/Container/VBoxContainer/VBoxContainer2/Subtitle

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	toggle_buttons('enable')
	errorPanel.visible = false
	
	HighLevelNetworkHandler.connection_notification.connect(connect_client)

# ---------------------------------------------------------------------------- #

func _on_host_pressed() -> void:
	toggle_buttons('disable')
	var sucess = HighLevelNetworkHandler.start_server()
	
	if sucess:
		get_tree().change_scene_to_packed(gameScene)
	else:
		errorLabel.text = 'O servidor já foi criado por outro host'
		toggle_error_panel()

# ---------------------------------------------------------------------------- #

func _on_client_pressed() -> void:
	toggle_buttons('disable')
	HighLevelNetworkHandler.start_client()
	
func connect_client(sucess) -> void:
	if sucess: get_tree().change_scene_to_packed(gameScene)
	else:
		print('else')
		errorLabel.text = 'Erro ao conectar: servidor cheio ou offline'
		toggle_error_panel()

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

func toggle_buttons(operation) -> void:
	
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

func toggle_error_panel() -> void:
	print(errorPanel.is_visible_in_tree())
	errorPanel.visible = !errorPanel.is_visible_in_tree()
	
	if(!errorPanel.is_visible_in_tree()): toggle_buttons('enable')
	else: toggle_buttons('disable')

# ---------------------------------------------------------------------------- #

func _on_error_ok_pressed() -> void:
	errorLabel.text = 'Um erro aconteceu'
	toggle_error_panel()

# ---------------------------------------------------------------------------- #
