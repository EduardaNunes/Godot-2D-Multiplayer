extends Sprite2D

@onready var Player : CharacterBody2D = $".."

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	global_position = get_global_mouse_position()
	look_at(Player.position)
	rotation += PI

# ---------------------------------------------------------------------------- #
