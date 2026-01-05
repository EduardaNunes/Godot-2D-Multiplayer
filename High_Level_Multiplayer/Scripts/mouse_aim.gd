extends Sprite2D

@onready var Player : CharacterBody2D = $".."

# ---------------------------------------------------------------------------- #

func _ready() -> void:
	if not is_multiplayer_authority():
		visible = false


func _physics_process(delta: float) -> void:
	
	if is_multiplayer_authority():
		global_position = get_global_mouse_position()
		look_at(Player.position)
		rotation += PI

# ---------------------------------------------------------------------------- #
