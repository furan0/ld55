extends AudioStreamPlayer2D
class_name audio_effect

@export var audio_clips : Array[AudioStream]
@export var pitch_distortion := 0.0
@export var looping := false

func _ready():
	if looping:
		finished.connect(loop_ended)

func loop_ended():
	play(0.0)

func play_sound():

	if(len(audio_clips)<1):
		return
	var idx = randi_range(0,len(audio_clips)-1)
	
	stream = audio_clips[idx]
	if pitch_distortion > 0.1 :
		pitch_scale = randf_range(1.0-pitch_distortion,1.0+pitch_distortion)
	play(0.0)
	playing = true
	
func stop_play():
	playing = false

