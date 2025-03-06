extends Node

##################################################
signal attacked_player
# 플레이어가 공격당한 시그널(게임 오버)
signal done_warning
# Boss 등장 화면 경고(빨갛게 화면이 깜빡임) 종료 시그널
signal reset_game
# 게임 초기화 시그널

##################################################
func signal_attacked_player() -> void:
	emit_signal("attacked_player")

##################################################
func signal_done_warning() -> void:
	emit_signal("done_warning")

##################################################
func signal_reset_game() -> void:
	emit_signal("reset_game")
