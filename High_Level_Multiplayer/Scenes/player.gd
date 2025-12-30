extends CharacterBody2D

const speed : float = 500.0

# ---------------------------------------------------------------------------- #

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	# Only Run By Correct Client
	if is_multiplayer_authority():
		velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * speed
		move_and_slide()

# ---------------------------------------------------------------------------- #
