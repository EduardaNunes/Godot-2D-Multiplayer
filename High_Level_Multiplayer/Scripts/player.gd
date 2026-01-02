extends CharacterBody2D

@export var snowball : PackedScene
@onready var camera = $Camera2D

# exported to sync
@export var lifes : int = 3 
signal took_damage(new_lifes)

const speed : float = 100.0

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

func setCameraPriority() -> void:
	if is_multiplayer_authority():
		camera.enabled = true
		camera.make_current()
	else:
		camera.enabled = false
		
# ---------------------------------------------------------------------------- #

func take_damage(damage: int) -> void:
	
	lifes -= damage
	took_damage.emit(lifes)
	print('Jogador "', self.name, '" tomou dano | vidas restantes: ', lifes)
	
	if lifes <= 0: die()
	
# ---------------------------------------------------------------------------- #

func die() -> void:
	print('Jogador "', self.name, '" morreu.')
