extends Node

##################################################
const BGM_FILE: AudioStream = \
	preload("res://sounds/spaceship shooter.wav")
# 배경 음악 파일
const P_FIRE_SOUND_FILE: AudioStream = \
	preload("res://sounds/maou_se_battle_gun05.wav")
# 플레이어 발사 소리 파일
const ATTACKED_SOUND_FILE: AudioStream = \
	preload("res://sounds/maou_se_battle_explosion05.wav")
# 피격 소리 파일

var bgm_sound_player: AudioStreamPlayer
var p_fire_effect_sound_player: AudioStreamPlayer
var attacked_effect_sound_player: AudioStreamPlayer
# 각 소리 재생 플레이어

##################################################
func _ready() -> void:
	bgm_sound_player = AudioStreamPlayer.new()
	add_child(bgm_sound_player)
	bgm_sound_player.stream = BGM_FILE
	bgm_sound_player.volume_db = -15.0
	bgm_sound_player.play()
	# 배경 음악 플레이어 설정 및 재생
	
	p_fire_effect_sound_player = AudioStreamPlayer.new()
	add_child(p_fire_effect_sound_player)
	p_fire_effect_sound_player.stream = P_FIRE_SOUND_FILE
	p_fire_effect_sound_player.volume_db = -10.0
	# 플레이어 발사 소리 플레이어 설정
	
	attacked_effect_sound_player = AudioStreamPlayer.new()
	add_child(attacked_effect_sound_player)
	attacked_effect_sound_player.stream = ATTACKED_SOUND_FILE
	attacked_effect_sound_player.volume_db = -15.0
	# 피격 소리 플레이어 설정

##################################################
func play_p_fire_effect_sound() -> void:
	p_fire_effect_sound_player.play()
	# 플레이어 발사 소리 재생

##################################################
func play_attacked_effect_sound() -> void:
	attacked_effect_sound_player.play()
	# 피격 소리 재생
