extends Area2D

##################################################
const MOVING_SPEED: float = 150.0
# Bullet 이동 속도

var direction
# 이동 방향
var phase: int = 1
# Boss 공격 패턴
var time_ratio: float = 0.0
# Phase_2에서 베지어 곡선을 그리는데 사영되는 변수

var start_point = Vector2(randf_range(160.0, 200.0), randf_range(20.0, 40.0))
var middle_point = Vector2(randf_range(0.0, 360.0), randf_range(310.0, 330.0))
var end_point = Vector2(randf_range(160.0, 200.0), randf_range(620.0, 640.0))
# Phase_2에서 베지어 곡선 관련 좌표들

##################################################
func _ready() -> void:	
	z_index = -9
	# 그리기 순서 설정
	
	add_to_group("BossBullet")
	# BossBullet 그룹에 추가
	connect("body_entered", Callable(self, "_on_body_entered"))
	# body_entered 시 _on_body_entered 함수 실행 연결

##################################################
func _physics_process(delta: float) -> void:
	if position.x <= -10.0 or position.x >= 370.0 or \
		position.y <= -10.0 or position.y >= 650.0:
		queue_free()
	# 화면 일정 거리 이상으로 나가면 지움
	
	if phase == 2:
	# 베지어 곡선을 그리며 공격하는 phase
		time_ratio += 0.5 * delta
		global_position = make_bezier_path(time_ratio)
		# 증가하는 time_ratio에 따라 베지어 곡선 경로로 좌표 설정
		
		if time_ratio >= 1:
			queue_free()
		# time_ratio가 1보다 크다는 것은 end_point 변수 이상으로 이동했다는 뜻
	else:
	# Phase_1이면
		position += direction * MOVING_SPEED * delta
		# 설정된 방향대로 발사. 360도 돌며 발사하게 됨

##################################################
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
	# body가 Player 그룹이면
		SB.signal_attacked_player()
		# 플레이어가 공격 당했다는 시그널 발산
		queue_free()
		# Bullet은 지움

##################################################
func set_direction(direction_value: Vector2) -> void:
	direction = direction_value
# Boss 씬에서 사용하는 함수

##################################################
func set_phase(phase_value) -> void:
	phase = phase_value
# Boss 씬에서 사용하는 함수

##################################################
func make_bezier_path(time_value: float) -> Vector2:
	var m0 = start_point.lerp(middle_point, time_value)
	# start_point와 middle_point의 time_value에 따른 보간
	var m1 = middle_point.lerp(end_point, time_value)
	# middle_point와 end_point의 time_value에 따른 보간
	var return_value = m0.lerp(m1, time_value)
	# m0와 m1의 time_value에 따른 보간
	return return_value
	# 결과 값 반환
