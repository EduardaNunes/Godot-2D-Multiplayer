extends CharacterBody2D

const speed : float = 100.0
@onready var camera = $Camera2D;

# ---------------------------------------------------------------------------- #

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	setCameraPriority();

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	if not multiplayer.has_multiplayer_peer(): return
	
	# Only Run By Correct Client
	if is_multiplayer_authority():
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
		move_and_slide()

# ---------------------------------------------------------------------------- #

func setCameraPriority():
	if is_multiplayer_authority():
		camera.enabled = true
		camera.make_current()
	else:
		camera.enabled = false
		
# ---------------------------------------------------------------------------- #
