# ---------------------------------------------------------------------------- #

extends AnimationTree

@onready var player : CharacterBody2D = $".."

var state_machine : AnimationNodeStateMachinePlayback
var last_facing_direction : int = -1
	
# ---------------------------------------------------------------------------- #

func _ready() -> void:
	state_machine = get("parameters/playback")
	
	player.took_damage.connect(play_hurt_animation)
	player.player_died.connect(play_death_animation)

# ---------------------------------------------------------------------------- #

func _physics_process(delta: float) -> void:
	
	var idle = !player.velocity.is_zero_approx() # avoids residual values by multiplayer connection
	
	if !idle : last_facing_direction = sign(player.velocity.x)

	set("parameters/Idle/blend_position", last_facing_direction)
	set("parameters/Run/blend_position", last_facing_direction)
	set("parameters/Trow/blend_position", last_facing_direction)
	set("parameters/Hurt/blend_position", last_facing_direction)
	set("parameters/Death/blend_position", last_facing_direction)
	
# ---------------------------------------------------------------------------- #

func play_trow_animation():
	state_machine.travel("Trow")
	
# ---------------------------------------------------------------------------- #

func play_hurt_animation(_new_lifes):
	state_machine.travel("Hurt")
	
# ---------------------------------------------------------------------------- #
	
func play_death_animation():
	state_machine.travel("Death")

# ---------------------------------------------------------------------------- #
