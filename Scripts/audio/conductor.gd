extends MusicPlayer
class_name Conductor


var rng = RandomNumberGenerator.new()
const songs = [
	"res://Assets/audio/audio/game/GGJ24_Track_1_Demo_110_BPM_C_Minor.wav",
	"res://Assets/audio/audio/game/Basic_Ah_Beat_120BPM.wav",
]
var playNextAt: float # when to play the next song


func _ready():
	load_song(songs[1], "", 0, 0)
	queue[0].bpm = 120
	queue[0].spb = 60.0 / 120
	play_next()
	
func play_next():
	var s = super.play_next()
	playNextAt = -1.0
	return s

func select_next_song():
	# TODO: how do we select the song better
	var s = load_song(songs[rng.randi_range(0, songs.size() - 1)], "")
	
	for fx in s.fxs:
		if fx.type == SongFX.EFFECT.FADE_IN:
			# use fade in duration to change the tempos of both tracks
			s.create_fx(SongFX.new(s, SongFX.EFFECT.BPM_CHANGE, s.songStartPos, fx.durationBeats, Vector2(playing[0].bpm, 0)))
			
			playNextAt = playing[0].songEndPos - playing[0]._to_duration(fx.durationBeats)
			s.create_fx(SongFX.new(s, SongFX.EFFECT.BPM_CHANGE, playNextAt, fx.durationBeats, Vector2(0, s.bpm)))

func _on_song_beat(song: Song):
	super._on_song_beat(song)
	
	var barBeat = song.get_bars_and_beats()
	print("bpm: ", song.get_current_bpm(), ", bar: ", barBeat[0], ", beat: ", barBeat[1], ", remaining (s): ", song.get_remaining(), "=", song.get_remaining_beats(), "beats")
	beat.emit(song)
	
	if playNextAt > 0 and song.songPos > playNextAt:
		var s = play_next()
		var overBeat = barBeat[1] - int(barBeat[1])
		s.player.seek(s.player.get_playback_position() - s._to_duration(overBeat))
	
	if playing.size() < 2 and queue.size() == 0:
		select_next_song()

func _on_song_stop(song: Song):
	super._on_song_stop(song)
	if playing.length() == 0:
		play_next() # incase there is no transition, play the next track
