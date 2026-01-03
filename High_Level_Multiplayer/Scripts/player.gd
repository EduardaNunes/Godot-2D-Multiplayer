extends CharacterBody2D

@onready var camera = $Camera2D
@onready var idle_sprite : AnimatedSprite2D = $AnimatedSprite2D

# exported to sync
@export var lifes : int = 3 
var color : String
signal took_damage(new_lifes)

const speed : float = 100.0

# ---------------------------------------------------------------------------- #

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	set_camera_priority()
	set_player_color()

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	if not multiplayer.has_multiplayer_peer(): return
	
	# Only Run By Correct Client
	if is_multiplayer_authority():
		
		# player movement
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
		move_and_slide()
		
		# player trowing snowballs
		if Input.is_action_just_pressed("shoot"):
			HighLevelNetworkHandler.player_trow_snowball.emit(global_position, $MouseAim.global_rotation, name)

# ---------------------------------------------------------------------------- #

func set_camera_priority() -> void:
	if is_multiplayer_authority():
		camera.enabled = true
		camera.make_current()
	else:
		camera.enabled = false
		
# ---------------------------------------------------------------------------- #

func set_player_color() -> void:
	match(color):
		'green':
			idle_sprite.
		'blue':
			pass
		'yellow':
			pass
		'red':
			pass
		_:
			print('Erro ao definir cor para o jogador')

func take_damage(damage: int) -> void:
	
	if not multiplayer.is_server(): return
	
	var new_lifes = lifes - damage
	update_lifes.rpc(new_lifes)
	
# ---------------------------------------------------------------------------- #

@rpc("call_local", "any_peer") 
func update_lifes(new_value):
	
	lifes = new_value
	took_damage.emit(lifes)
	
	if lifes <= 0 and multiplayer.is_server(): die()
		
# ---------------------------------------------------------------------------- #

func die() -> void:
	print('Jogador "', self.name, '" morreu.')
	
# ---------------------------------------------------------------------------- #
	
