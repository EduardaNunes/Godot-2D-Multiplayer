extends Area2D

var velocity = Vector2.ZERO
var speed = 200
var shooter_id = 0

# ---------------------------------------------------------------------------- #

func _ready():
	await get_tree().create_timer(3.0).timeout
	if multiplayer.is_server():
		queue_free()

# ---------------------------------------------------------------------------- #

func _physics_process(delta):
	position += velocity * speed * delta
	
# ---------------------------------------------------------------------------- #

func _on_body_entered(body):
	
	# Handle by Server
	if not multiplayer.is_server(): return
	# Ignores the shooter
	if body.name == str(shooter_id): return
	
	if body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()

# ---------------------------------------------------------------------------- #
