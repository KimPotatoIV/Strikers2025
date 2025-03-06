extends Area2D

##################################################
const ENEMIES_BULLET_SCENE: PackedScene = \
	preload("res://scenes/enemies/enemies_bullet/enemies_bullet.tscn")
# Enemy 전용 Bullet 씬 미리 불러오기

var anim_node: AnimatedSprite2D
var collision_node: CollisionShape2D
var timer_node: Timer
# 각 노드 선언

##################################################
func _ready() -> void:
	anim_node = $AnimatedSprite2D
	collision_node = $CollisionShape2D
	timer_node = $Timer
	timer_node.wait_time = 1.0
	# 각 노드 설정
	timer_node.start()
	# timer_node 노드 바로 시작
	# 타이머가 울리면 플레이어를 향해 Bullet 발사
	
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, true)
	# mask_value을 false 해야 플레이어 이동 제한용 벽을 뚫고 화면 안으로 이동이 가능함
	
	timer_node.connect("timeout", Callable(self, "_on_timer_timeout"))
	# timeout 시 _on_timer_timeout 함수 실행 연결
	connect("body_entered", Callable(self, "_on_body_entered"))
	# body_entered 시 _on_body_entered 함수 실행 연결
	connect("area_entered", Callable(self, "_on_area_entered"))
	# area_entered 시 _on_area_entered 함수 실행 연결
	
	add_to_group("Enemy")
	# player_bullet 스크립트에서 사용

##################################################
func _physics_process(delta: float) -> void:
	position.y += delta * 200
	# 위에서 아래로 이동
	
	if position.y >= 700.0:
		queue_free()
	# 화면 일정 거리 밖으로 벗어나면 지움

##################################################
func _process(delta: float) -> void:
	if not anim_node.is_playing():
	# 애니메이션이 재생 중이 아니면(explosion 재생이 완료되면)
		queue_free()
		GM.set_enemies_count(GM.get_enemies_count() + 1)
		# 지우고 게임 매니저(GM)의 count 올림
	elif position.y >= 650.0:
	# 화면 일정 거리 이상 벗어나면
		queue_free()
		GM.set_enemies_count(GM.get_enemies_count() + 1)
		# 지우고 게임 매니저(GM)의 count 올림

##################################################
func _on_timer_timeout() -> void:
	fire_bullet()
# 타이머가 울리면 bullet 발사

##################################################
func fire_bullet() -> void:
	var bullet_instance = ENEMIES_BULLET_SCENE.instantiate()
	# Bullet 인스턴스 생성
	bullet_instance.global_position = global_position
	# Enemy 좌표로 설정
	get_tree().get_nodes_in_group("EnemiesBullets").front().add_child(bullet_instance)
	timer_node.stop()
	# EnemiesBullets 그룹을 가진 씬에 자식 노드로 추가
	# Enemy의 이동과 Bullet의 이동에 서로 영향을 주지 않기 위함
	# Bullet은 한 발만 발사하기 때문에 타이머 정지

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
	# body가 Player 그룹이면
		SB.signal_attacked_player()
		# 플레이어가 공격 당했다는 시그널 발산
		
		anim_node.play("explosion")
		# explosion 애니메이션 재생
		call_deferred("collision_disabled")
		# collision 사용 중지는 지연호출을 해야 오류가 없음

##################################################
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
	# area가 PlayerBullet 그룹이면
		anim_node.play("explosion")
		# explosion 애니메이션 재생
		call_deferred("collision_disabled")
		# collision 사용 중지는 지연호출을 해야 오류가 없음
		SM.play_attacked_effect_sound()
		# 피격 효과음 재생

##################################################
func collision_disabled() -> void:
	collision_node.disabled = true
	# collision 사용 중지
