# ---------------------------------------------------------------------------- #

extends AnimationTree

@onready var player : CharacterBody2D = $".."
@onready var player_collision : CollisionShape2D = $"../CollisionShape2D"

var state_machine : AnimationNodeStateMachinePlayback
var last_facing_direction : int = -1
	
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	state_machine = get("parameters/playback")
	state_machine.state_finished.connect(enable_player_movement)
	
	player.took_damage.connect(play_hurt_animation)
	player.player_died.connect(play_death_animation)
	
# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	var idle = player.velocity.is_zero_approx() # avoids residual values by multiplayer connection

	if !idle : last_facing_direction = player.velocity.x

	set("parameters/Idle/blend_position", last_facing_direction)
	set("parameters/Run/blend_position", last_facing_direction)
	set("parameters/Trow/blend_position", last_facing_direction)
	set("parameters/Hurt/blend_position", last_facing_direction)
	set("parameters/Death/blend_position", last_facing_direction)
	
# ---------------------------------------------------------------------------- #

func play_trow_animation():
	player.set_physics_process(false)
	state_machine.travel("Trow")
	
# ---------------------------------------------------------------------------- #

func play_hurt_animation(_new_lifes):
	player.set_physics_process(false)
	player_collision.set_deferred("disabled", true)
	state_machine.travel("Hurt")
	
# ---------------------------------------------------------------------------- #
	
func play_death_animation():
	state_machine.travel("Death")

# ---------------------------------------------------------------------------- #

func enable_player_movement(state):
	if state == "Trow" or state == "Hurt": 
		player.set_physics_process(true)
		player_collision.set_deferred("disabled", false)
