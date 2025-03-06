extends CanvasLayer

##################################################
var game_over_label_node: Label
var game_clear_label: Label
var color_rect_node: ColorRect
var anim_player_node: AnimationPlayer
# 각 변수 선언

var played_animation: bool = false
# Boss 등장 시 화면 효과를 한 번만 재생하기 위한 변수

##################################################
func _ready() -> void:
	game_over_label_node = $GameOverLabel
	game_clear_label = $GameClearLabel
	color_rect_node = $ColorRect
	anim_player_node = $AnimationPlayer
	# 각 노드 설정
	
	color_rect_node.visible = false
	# Boss 등장 시 사용하는 노드이기 때문에 일단 꺼둠
	anim_player_node.connect("animation_finished", \
		Callable(self, "_on_animation_finished"))
	# animation_finished 시 _on_animation_finished 함수 실행 연결
	SB.connect("reset_game", Callable(self, "_on_reset_game"))
	# 시그널 버스(SB)가 reset_game 시그널 발산 시 _on_reset_game 함수 실행 연결

##################################################
func _process(delta: float) -> void:
	game_over_label_node.visible = GM.get_game_over()
	game_clear_label.visible = GM.get_game_clear()
	# 각 노드 게임 오버 여부 및 게임 클리어 여부에 따라 보여짐 설정
	
	if GM.get_enemies_count() == 10 and not played_animation:
	# enemy count가 10마리 됐다면
		played_animation = true
		color_rect_node.visible = true
		anim_player_node.play("warning")
		# warning 애니메이션(빨간 경고 배경) 재생

##################################################
func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "warning":
	# warning 애니메이션이 재생 종료 시
		SB.signal_done_warning()
		# 시그널 버스(SB) done_warning 발산
		anim_player_node.stop()
		# 애니메이션 정지
		color_rect_node.visible = false
		# 노드 가림

##################################################
func _on_reset_game() -> void:
	played_animation = false
	# 게임 리셋 시 변수 초기화
