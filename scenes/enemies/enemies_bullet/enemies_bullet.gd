extends Area2D

##################################################
const MOVING_SPEED: float = 300.0
# 적 Bullet 이동 속도

var player_position
# Player 방향으로 발사하기 위해 선언
var direction
# 발사 방향

##################################################
func _ready() -> void:
	z_index = -1
	# 그리기 순서 설정
	
	player_position = get_tree().get_first_node_in_group("Player").position
	# Player 그룹을 찾아(Player 씬 하나임) 좌표 설정
	direction = Vector2(player_position - position).normalized()
	# Bullet 발사 방향 설정
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	# body_entered 시 _on_body_entered 함수 실행 연결

##################################################
func _process(delta: float) -> void:
	position += direction * MOVING_SPEED * delta
	# direction에 따라 이동
	
	if position.x <= -10.0 or position.x >= 370.0 or \
		position.y <= -10.0 or position.y >= 650.0:
		queue_free()
	# 화면 일정 거리 이상으로 벗어나면 지움

##################################################
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
	# body가 Player 그룹이면
		SB.signal_attacked_player()
		queue_free()
		# 플레이어가 공격 당했다는 시그널 발산 및 지움
