extends Control

#@export var menuScene : PackedScene
@onready var audioPlayer : AudioStreamPlayer2D = $AudioStreamPlayer2D

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	self.visible = false
	
# ---------------------------------------------------------------------------- #
	
func _process(delta: float) -> void:
	
	if not multiplayer.has_multiplayer_peer(): return
	if not is_multiplayer_authority(): return
	
	if Input.is_action_just_pressed('esc'):
		self.visible = !self.is_visible_in_tree()
		
# ---------------------------------------------------------------------------- #

func _on_exit_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	
	multiplayer.multiplayer_peer = null
	#get_tree().change_scene_to_packed(menuScene)
	get_tree().change_scene_to_file(HighLevelNetworkHandler.MENU_SCENE_PATH)

# ---------------------------------------------------------------------------- #

func _on_cancel_pressed() -> void:
	audioPlayer.play()
	await audioPlayer.finished
	
	self.visible = false

# ---------------------------------------------------------------------------- #
