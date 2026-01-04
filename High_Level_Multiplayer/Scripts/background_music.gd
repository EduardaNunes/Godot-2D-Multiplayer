extends Node

@onready var musicPlayer = $AudioStreamPlayer

func play_music(newMusic: AudioStream):
	if musicPlayer.stream == newMusic and musicPlayer.playing:
		return
	
	musicPlayer.stream = newMusic
	musicPlayer.play()

func stop_music():
	musicPlayer.stop()
