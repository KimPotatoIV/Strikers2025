extends Area2D

##################################################
const BULLET_SCENE: PackedScene = \
	preload("res://scenes/enemies/boss_bullet/boss_bullet.tscn")
# Boss 전용 Bullet 씬 미리 불러오기

var anim_node: AnimatedSprite2D
var fire_timer_node: Timer
# 각 노드 선언
# fire_timer_node는 총알 발사 속도를 조절하는 타이머

var max_health: int = 100
var current_health: int = max_health
var angle: float = 0
var fire: bool = false
# 각 노드 선언 및 초기화
# angle은 발사 각도

##################################################
func _ready() -> void:
	anim_node = $AnimatedSprite2D
	fire_timer_node = $FireTimer
	fire_timer_node.wait_time = 0.05
	# 각 노드 설정
	fire_timer_node.autostart = true
	
	add_to_group("Boss")
	# Boss 그룹에 추가. Player Bullet에서 사용
	z_index = -8
	# 그리기 순서 설정
	
	fire_timer_node.connect("timeout", Callable(self, "_on_fire_timer_timeout"))
	# fire_timer_node timeout 시 _on_fire_timer_timeout 함수 실행 연결
	connect("area_entered", Callable(self, "_on_area_entered"))
	# area_entered 시 _on_area_entered 함수 실행 연결
	SB.connect("attacked_player", Callable(self, "_on_attacked_player"))
	# 시그널 버스(SB) attacked_player 발산 시 _on_attacked_player 함수 실행 연결

##################################################
func _physics_process(delta: float) -> void:
	if position.y >= 90.0:
		position.y = 90.0
		return
	
	position.y += delta * 100
	# 처음 등장 시 위에서 아래로 이동 및 일정 위치에 오면 정지

##################################################
func _process(delta: float) -> void:
	angle += delta * 5000
	# angle값이 계속 늘어난다는 것은 발사 각도가 360도 계속 돈다는 뜻
	if current_health <= 90 and current_health > 45:
		if fire:
			fire = false
			fire_bullet_phase_1()
	# 일정 체력 동안에는 phase_1 공격. 360도 돌면서 Bullet을 뿌림
	elif current_health <= 45 and current_health > 0:
		if fire:
			fire = false
			fire_bullet_phase_2()
	# 일정 체력 동안에는 phase_2 공격. 베지어 곡선으로 Bullet을 뿌림
	elif current_health <= 0:
		anim_node.play("explosion")
		GM.set_game_clear(true)
	# 체력이 다 달으면 폭발

##################################################
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("PlayerBullet"):
		current_health -= 1
		SM.play_attacked_effect_sound()
	# 플레이어에게 공격당하면 체력이 달으며 효과음 재생

##################################################
func fire_bullet_phase_1() -> void:
	var bullet_instance = BULLET_SCENE.instantiate()
	# Bullet 인스턴스 생성
	var direction = Vector2(cos(angle), sin(angle))
	# 발사 방향 설정. 늘어나는 angle 값에 따라 360도 돌음
	bullet_instance.set_direction(direction)
	# Bullet 씬의 direction을 설정
	bullet_instance.global_position = global_position
	# Boss 좌표에서 발사되도록 설정
	get_tree().get_nodes_in_group("EnemiesBullets").front().add_child(bullet_instance)
	# EnemiesBullets 그룹을 가진 씬에 자식 노드로 추가
	# Boss의 이동과 Bullet의 이동에 서로 영향을 주지 않기 위함

##################################################
func fire_bullet_phase_2() -> void:
	fire_timer_node.wait_time = 0.5
	# 발사 속도 조정
	var bullet_instance = BULLET_SCENE.instantiate()
	# Bullet 인스턴스 생성
	bullet_instance.global_position = global_position
	# Boss 좌표에서 발사되도록 설정
	bullet_instance.set_phase(2)
	# Bullet 씬에 phase_2라고 알려줌
	# Bullet 씬에서 phase_2라면 베지어 곡선을 그리며 공격하기 시작
	
	get_tree().get_nodes_in_group("EnemiesBullets").front().add_child(bullet_instance)
	# EnemiesBullets 그룹을 가진 씬에 자식 노드로 추가
	# Boss의 이동과 Bullet의 이동에 서로 영향을 주지 않기 위함

##################################################
func _on_fire_timer_timeout() -> void:
	fire = true
# 이 변수가 있어야 _process() 실행 간격과 상관 없이 타이머에 맞춰 Bullet을 발사함

##################################################
func _on_attacked_player() -> void:
	queue_free()
# 플레이어가 공격 받으면(게임 오버) Boss 지움
