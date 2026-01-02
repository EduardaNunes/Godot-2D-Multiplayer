extends Control

@export var buttons : Array[Button]

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	toggle_buttons('enable')

# ---------------------------------------------------------------------------- #

func _on_back_pressed() -> void:
	toggle_buttons('disable')
	get_tree().change_scene_to_file(HighLevelNetworkHandler.MENU_SCENE_PATH)
	
# ---------------------------------------------------------------------------- #

func toggle_buttons(operation):
	
	if operation == 'disable' :
		operation = true
	elif operation == 'enable':
		operation = false
	else:
		print('operação inválida. Esperado: disable ou enable. Recebido: ', operation)
		return
		
	for button in buttons:
		button.disabled = operation

# ---------------------------------------------------------------------------- #
