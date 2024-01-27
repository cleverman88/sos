extends Node
class_name Song

# TODO: looping functionality?
# TODO: create and load data from a file

# track control signals
signal song_start
signal song_stop

# gameplay sync signals
signal song_beat

const MIN_VOL = -35.0
const MAX_VOL = 0

var source: String
var player: AudioStreamPlayer

var bpm: float
var spb: float # seconds per beat

# control data for the song to come in/out smoothly
var startPos: float
var fadeOutPos: float
var fadeInDuration: float
var fadeOutDuration: float

# position info directly from the song
var started = false
var fadeOutBegun = false
var startedTime: float
var dspTime: float
var songPos: float
var songPosBeats: float

var lastBeatPos: float

func _init(song_path: String, data_path: String, fade_in_override = -1):
	if not FileAccess.file_exists(song_path):
		push_error("could not find audio file: " + song_path)
		return
	#if not FileAccess.file_exists(data_path):
		#push_error("could not find data file: " + data_path)
		#return
	
	source = song_path
	player = AudioStreamPlayer.new()
	player.bus = "master"
	player.stream = load(song_path)
	player.volume_db = MIN_VOL
	
	_load_metadata(data_path, fade_in_override)
	
func _load_metadata(data_path: String, fade_in_override = -1):
	# TODO: load bpm, start time, fade data from data_path
	bpm = 110.0
	spb = 60.0 / bpm
	
	startPos = 0.271 # TODO: not EXACTLY right, mr audio guy needs to sort this for me 
	fadeOutPos = -1
	if fadeOutPos == -1:
		fadeOutPos = player.stream.get_length()
	 
	var fadeInBeats	= 16
	var fadeOutBeats = 0
	fadeInDuration = (fade_in_override if fade_in_override >= 0 else fadeInBeats) * spb
	fadeOutDuration = fadeOutBeats * spb

func play():
	startedTime = Time.get_unix_time_from_system()
	player.play(startPos)
	started = true
	fadeOutBegun = false
	song_start.emit(startedTime)
	
func stop():
	player.stop()
	started = false
	song_stop.emit(source)

func get_bars_and_beats() -> Vector2:
	var bars = floor(songPosBeats / 4)
	return Vector2(bars, songPosBeats - (4*bars))
	
func set_playback_bpm(newBpm):
	player.pitch_scale = newBpm / bpm

func _process(delta):
	if started: 
		var pos = player.get_playback_position()
		songPos = pos - startPos
		songPosBeats = songPos / spb - 1
		dspTime = Time.get_unix_time_from_system() - startedTime

		# manage fade in / out of music
		if songPos < fadeInDuration:
			player.volume_db = MIN_VOL + (MAX_VOL - MIN_VOL) * (songPos / fadeInDuration)
		elif songPos > fadeOutPos + fadeOutPos:
			stop()
		elif songPos > fadeOutPos:
			player.volume_db = MAX_VOL - (MAX_VOL - MIN_VOL) * ((songPos - fadeOutPos) / fadeInDuration)
		elif player.volume_db != MAX_VOL:
			player.volume_db = MAX_VOL
		
		# emit beat signal
		if songPos > lastBeatPos + spb:
			song_beat.emit(get_bars_and_beats())
			lastBeatPos += spb
