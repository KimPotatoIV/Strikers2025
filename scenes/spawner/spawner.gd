extends Node2D

##################################################
const ENEMY_SCENE: PackedScene = preload("res://scenes/enemies/enemy/enemy.tscn")
const BOSS_SCENE: PackedScene = preload("res://scenes/enemies/boss/boss.tscn")
# 소환할 각 씬 미리 불러오기

var timer_node: Timer
var enemy_count: int = 0
# 각 노드 설정 및 초기화

##################################################
func _ready() -> void:
	timer_node = $Timer
	timer_node.wait_time = 1.0
	timer_node.start()
	# timer_node 설정
	
	timer_node.connect("timeout", Callable(self, "_on_timer_timeout"))
	# timeout 시 _on_timer_timeout 함수 실행 연결
	SB.connect("done_warning", Callable(self, "_on_done_warning"))
	# done_warning 시 _on_done_warning 함수 실행 연결
	SB.connect("reset_game", Callable(self, "_on_reset_game"))
	# reset_game 시 _on_reset_game 함수 실행 연결

##################################################
func _on_done_warning() -> void:
# Boss 등장 경고 애니메이션 재생 종료 시(빨갛게 화면이 깜빡거림)
	var boss_instance = BOSS_SCENE.instantiate()
	# 보스 인스턴스 생성
	boss_instance.position = Vector2(180.0, -130.0)
	# 좌표 설정
	add_child(boss_instance)
	# 자식 노드로 추가

##################################################
func _on_timer_timeout() -> void:
	if not GM.get_game_over():
	# 게임 오버가 아니라면
		if enemy_count < 10:
			var enemy_instance = ENEMY_SCENE.instantiate()
			enemy_instance.position = \
				Vector2(randf_range(20.0, 340.0), -20.0)
			add_child(enemy_instance)
			# 적 인스턴스화 및 좌표 설정
			
			enemy_count += 1
			timer_node.start()
			# 타이머 재시작. 일정 주기로 소환하기 위함

##################################################
func _on_reset_game() -> void:
	enemy_count = 0
# 게임 초기화 시 변수 초기화
