extends Control

@export var mainMenuScene : PackedScene

# --------------------------------------------------------------------------- #

func _ready() -> void:
	self.visible = false
	
# --------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	if Input.is_key_pressed(KEY_ESCAPE):
		if is_multiplayer_authority():
			self.visible = true
		
# --------------------------------------------------------------------------- #

func _on_exit_pressed() -> void:
	
	HighLevelNetworkHandler.server.disconnect_peer(multiplayer.multiplayer_peer.get_packet_peer())
	get_tree().change_scene_to_packed(mainMenuScene)

# --------------------------------------------------------------------------- #

func _on_cancel_pressed() -> void:
	self.visible = false

# --------------------------------------------------------------------------- #
