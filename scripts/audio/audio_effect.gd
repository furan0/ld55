extends AudioStreamPlayer2D
class_name audio_effect

@export var audio_clips : Array[AudioStream]
@export var pitch_distortion := 0.0
@export var looping := false

@export var loop_attenuation = -20.0

var initial_volume := 0.0

func _ready():
	panning_strength = 3.0
	initial_volume = volume_db
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
	playing = true
	if looping:
		play(randf_range(0.0,stream.get_length()))
		print("oui")
		volume_db = initial_volume
		get_tree().create_tween().tween_property(self,"volume_db",loop_attenuation,0.4)
	
	
func stop_play():
	playing = false

