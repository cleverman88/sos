class_name SongFX

# (fx SongFx, song Song)
signal effect_begin
signal effect_end


const MIN_VOL = -35.0
const MAX_VOL = 0
enum EFFECT {
	FADE_IN, FADE_OUT,		# supply Vector2(start_volume, end_volume), or null to use min/max
	BPM_CHANGE,				# supply Vector2(start_bpm, target_bpm). If either value is 
	LOOP					# supply times we loop. If null, loop forever. If durationBeats = null we will loop on end
}


var active = false
var startPos: float
var duration: float
var durationBeats: float
var completePos: float
var type: EFFECT
var data


func _init(song: Song, transition: EFFECT, begin_at: float, durationInBeats: float, d = null):
	startPos = begin_at # TODO: beginAtBeats? beginAtBars?
	durationBeats = durationInBeats
	duration = startPos + (durationBeats * song.spb)
	completePos = startPos + duration
	type = transition
	data = d
	
	if data == null:
		if type == EFFECT.FADE_IN:
			data = Vector2(MIN_VOL, MAX_VOL)
		if type == EFFECT.FADE_OUT:
			data = Vector2(MAX_VOL, MIN_VOL)
	
	if type == EFFECT.BPM_CHANGE:
		if data == null:
			printerr("TRYING TO CHANGE BPM WITH NO DATA")
			data = Vector2(0.0, 0.0)
		if data[0] == 0.0:
			data[0] = song.bpm
		if data[1] == 0.0:
			data[1] = song.bpm
	
	if type == EFFECT.LOOP and durationBeats == 0:
			durationBeats = song.player.stream.get_length()
			song.player.finished.disconnect(song.stop)
			song.player.finished.connect(song.play)

func _process(song: Song):
	if not active and song.songPos > startPos:
		active = true
		effect_begin.emit(self, song)
	if active:
		# get current position bounded by duration
		var pos = song.songPos
		if pos > completePos:
			pos = completePos
		var progress = (pos - startPos) / duration
		
		# apply effect
		if type == EFFECT.FADE_IN or type == EFFECT.FADE_OUT:
			song.set_playback_volume(data[0] + (data[1] - data[0]) * progress)
		if type == EFFECT.BPM_CHANGE:
			song.set_playback_bpm(data[0] + (data[1] - data[0]) * progress)
		
		# end event if we went over time
		if pos == completePos:
			if type == EFFECT.LOOP:
				if data != null:
					song.player.seek(song.player.get_playback_position() - duration)
					song.lastBeatPos -= duration
					data -= 1
					if data == 0:
						effect_end.emit(self, song)
			elif type == EFFECT.FADE_IN or type == EFFECT.FADE_OUT or type == EFFECT.BPM_CHANGE:
				effect_end.emit(self, song)
