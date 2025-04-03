extends Node

const SFX_POLYPHONY: int = 32
const FADE_TIME: float = 1.5

const FLOATING_GARDEN = "res://assets/audio/music/floating-garden.ogg"
const HEARTY = "res://assets/audio/music/hearty.ogg"
const LONGNIGHT = "res://assets/audio/music/longnight.ogg"
const YESTERDAY = "res://assets/audio/music/yesterday.ogg"

var music_tracks: Array[String] = [FLOATING_GARDEN, HEARTY, LONGNIGHT, YESTERDAY]

var music_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null

var current_track: String


func _ready() -> void:
	randomize()
	_create_music_player()
	_create_sfx_player()
	process_mode = Node.PROCESS_MODE_ALWAYS


func play_sound(sound: Resource, volume_db: int = -2, pitch_multiplier: float = 0.0) -> void:
	var sfx_playback = sfx_player.get_stream_playback()
	sfx_playback.play_stream(sound, 0, volume_db, _get_random_pitch(pitch_multiplier))


func play_random_music() -> void:
	play_music(music_tracks.pick_random())


func play_music(track_path, volume_db: int = -20, crossfade: bool = true) -> void:
	if current_track == track_path:
		return
	current_track = track_path

	if crossfade and music_player.playing:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -40, FADE_TIME)
		tween.tween_callback(func():
			music_player.stop()
			music_player.stream = load(track_path)
			music_player.play()
		)
		tween.tween_property(music_player, "volume_db", volume_db, FADE_TIME)
	else:
		music_player.stream = load(track_path)
		music_player.volume_db = volume_db
		music_player.play()


func stop_music(fade_out: bool = true) -> void:
	if fade_out:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -40, FADE_TIME)
		tween.tween_callback(func(): music_player.stop())
	else:
		music_player.stop()


func _create_music_player() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)


func _create_sfx_player() -> void:
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	sfx_player.set_max_polyphony(SFX_POLYPHONY) # 32 default ?
	sfx_player.stream = AudioStreamPolyphonic.new()
	add_child(sfx_player)
	sfx_player.play()


func _get_random_pitch(multiplier: float = 0.0) -> float:
	return randf_range(0.8 - multiplier, 1.2 + multiplier)
