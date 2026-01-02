extends TextureProgressBar

func _ready() -> void:
	value = 100
	get_parent().took_damage.connect(update_lifes_bar)
	
func update_lifes_bar(lifes) -> void :
	
	match lifes:
		3: value = 100	
		2: value = 75
		1: value = 25	
		0: value = 0	
