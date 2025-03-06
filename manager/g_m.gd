extends Node

##################################################
var enemies_count: int = 0
var game_over: bool = true
var game_clear: bool = false
# 각 변수 선언 및 초기화

##################################################
func get_enemies_count() -> int:
	return enemies_count

##################################################
func set_enemies_count(count_value: int) -> void:
	enemies_count = count_value

##################################################
func get_game_over() -> bool:
	return game_over

##################################################
func set_game_over(game_over_value: bool) -> void:
	game_over = game_over_value

##################################################
func get_game_clear() -> bool:
	return game_clear

##################################################
func set_game_clear(game_clear_value: bool) -> void:
	game_clear = game_clear_value
