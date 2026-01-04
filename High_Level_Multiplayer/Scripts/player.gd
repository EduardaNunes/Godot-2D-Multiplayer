extends CharacterBody2D

@onready var camera : Camera2D = $Camera2D
@onready var collision : CollisionShape2D = $CollisionShape2D

# exported to sync
@export var lifes : int = 3 
@export var sync_velocity : Vector2 = Vector2.ZERO

signal took_damage(new_lifes)
signal player_died()

const speed : float = 100.0
var color : String

# ---------------------------------------------------------------------------- #

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	set_camera_priority()

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	if not multiplayer.has_multiplayer_peer(): return
	
	# Only Run By Correct Client
	if is_multiplayer_authority():
		
		# player movement
		velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down") * speed
		move_and_slide()
		sync_velocity = velocity
		
		# player trowing snowballss
		if Input.is_action_just_pressed("shoot"):
			HighLevelNetworkHandler.player_trow_snowball.emit(global_position, $MouseAim.global_rotation, name)
	else:
		velocity = sync_velocity
		move_and_slide()

# ---------------------------------------------------------------------------- #

func set_camera_priority() -> void:
	if is_multiplayer_authority():
		camera.enabled = true
		camera.make_current()
	else:
		camera.enabled = false
		
# ---------------------------------------------------------------------------- #

func take_damage(damage: int) -> void:
	
	if not multiplayer.is_server(): return
	
	var new_lifes = lifes - damage
	update_lifes.rpc(new_lifes)
	
# ---------------------------------------------------------------------------- #

@rpc("call_local", "any_peer") 
func update_lifes(new_value):
	
	lifes = new_value
	took_damage.emit(lifes)
	
	if lifes <= 0: die()
		
# ---------------------------------------------------------------------------- #

func die() -> void:
	set_physics_process(false)
	collision.set_deferred("disabled", true)
	player_died.emit()
	
# ---------------------------------------------------------------------------- #
