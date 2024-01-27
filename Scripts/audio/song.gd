extends Node
class_name Song

# track control signals
signal song_start # (song: Song)
signal song_stop  # (song: Song, ended_time: float)

# gameplay sync signals
signal song_beat # (song: Song)


var source: String
var player: AudioStreamPlayer

var bpm: float
var spb: float # seconds per beat
var songStartPos: float
var songEndPos: float

# position info directly from the song
var startedTime: float = -1
var dspTime: float
var songPos: float
var songPosBeats: float

var lastBeatPos: float


##################
##     INIT     ##
##################
func _init(song_path: String, fade_in_override = -1, fade_out_override = -1):
	if not FileAccess.file_exists(song_path):
		push_error("could not find audio file: " + song_path)
		return
	
	source = song_path
	player = AudioStreamPlayer.new()
	player.bus = "master"
	player.stream = load(song_path)
	player.finished.connect(stop)
	
	_load_metadata(song_path, fade_in_override, fade_out_override)
	
func _load_metadata(song_path: String, fade_in_override = -1, fade_out_override = -1):
	var file = "res://Assets/tracks/audio_meta.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	var meta = json_as_dict[song_path]
	
	bpm = meta["bpm"]
	spb = 60.0 / bpm
	
	songStartPos = meta["start"]
	songEndPos = meta["end"] if meta.has("end") else 0
	if songEndPos <= songStartPos:
		songEndPos = player.stream.get_length() - songStartPos
		
	# load effects 
	var fadeInBeats = (fade_in_override if fade_in_override >= 0 else 0) * spb
	if fadeInBeats != 0:
		create_fx(SongFX.new(self, SongFX.EFFECT.FADE_IN, songStartPos, fadeInBeats))
	
	var fadeOutBeats = (fade_out_override if fade_out_override >= 0 else 0) * spb
	if fadeOutBeats != 0:
		create_fx(SongFX.new(self, SongFX.EFFECT.FADE_OUT, songStartPos, fadeOutBeats))

##################
##    CONTROL   ##
##################
func play():
	startedTime = Time.get_unix_time_from_system()
	player.play(songStartPos)
	song_start.emit(self)
	
func stop():
	player.stop()
	song_stop.emit(self, Time.get_unix_time_from_system())

func set_playback_volume(db):
	player.volume_db = db

func set_playback_bpm(newBpm):
	player.pitch_scale = newBpm / bpm

##################
##     INFO     ##
##################
func get_playing() -> bool:
	return player.playing

func get_bars_and_beats() -> Vector2:
	var bars = floor(songPosBeats / 4)
	return Vector2(bars, songPosBeats - (4*bars))

func get_remaining() -> float:
	return songEndPos - songPos / player.pitch_scale

func get_current_bpm() -> float:
	return bpm * player.pitch_scale
	
func get_current_spb() -> float:
	return spb / player.pitch_scale

func get_remaining_beats() -> float:
	return _to_beats(get_remaining())
	
func get_duration_next_beat() -> float:
	return _to_duration(1 - (songPosBeats - int(songPosBeats)))

func _to_duration(beats) -> float:
	return beats * spb

func _to_beats(duration) -> float:
	return duration / spb - 1

##################
## UPDATE LOOP  ##
##################
func _process(_delta):
	if player.playing: 
		process_fx()
		update_song_pos()
		process_beat()

func update_song_pos():
	var pos = player.get_playback_position()
	songPos = pos - songStartPos
	songPosBeats = _to_beats(songPos)
	dspTime = Time.get_unix_time_from_system() - startedTime

func process_beat():
	if songPos > lastBeatPos + spb:
		song_beat.emit(self)
		lastBeatPos += spb

##################
##      FX      ##
##################
var fxs: Array = []
func create_fx(fx: SongFX):
	fx.effect_begin.connect(_on_fx_begin, CONNECT_ONE_SHOT)
	fx.effect_end.connect(_on_fx_end, CONNECT_ONE_SHOT)
	fxs.append(fx)
	
func process_fx():
	for fx in fxs:
		fx._process(self)

func _on_fx_begin(fx: SongFX, _song: Song):
	print("FX STARTED: ", fx.type)
	
func _on_fx_end(fx: SongFX, _song: Song):
	print("FX ENDED: ", fx.type)
	if fx.type == SongFX.EFFECT.FADE_OUT:
		stop()
	fxs.erase(fx)
