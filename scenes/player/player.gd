extends CharacterBody2D

##################################################
enum STATE {
	IDLE,
	LEFT,
	RIGHT,
	EXPLOSION
}
# Player 상태 열거형 변수

const PLAYER_BULLET_SCENE: PackedScene = \
	preload("res://scenes/player/player_bullets/player_bullet.tscn")
# player_bullet 미리 불러오기

const SPEED = 200.0
# 이동 속도

var anim_node: AnimatedSprite2D
var collision_node: CollisionShape2D
var state: STATE = STATE.IDLE
# 각 변수 선언 및 설정

##################################################
func _ready() -> void:
	anim_node = $AnimatedSprite2D
	collision_node = $CollisionShape2D
	# 각 노드 설정
	
	add_to_group("Player")
	# Player 그룹에 추가
	set_collision_layer_value(2, true)
	# 적과 충돌을 위한 layer 추가
	set_collision_mask_value(1, true)
	# 벽 이동 제한을 위한 mask 추가
	
	SB.connect("attacked_player", Callable(self, "_on_attacked_player"))
	# 시그널 버스(SB)에서 attacked_player 발산 시 _on_attacked_player 함수 실행 연결

##################################################
func _physics_process(delta: float) -> void:
	if GM.get_game_over():
	# 게임 오버라면
		if Input.is_action_just_pressed("ui_accept"):
		# 스페이스 키를 누르면
			reset_game()
			# 게임 리셋
	else:
		# 게임 오버가 아니라면
		if Input.is_action_just_pressed("ui_accept"):
		# 스페이스 키를 누르면
			fire_bullet()
			# bullet 발상
		
		var hor_direction: float = Input.get_axis("ui_left", "ui_right")
		var ver_direction: float = Input.get_axis("ui_up", "ui_down")
		# 좌우 및 상하 이동 값을 각 변수에 저잘
		if hor_direction:
		# 좌우 이동 값이 있다면
			velocity.x = hor_direction * SPEED
			# 좌우 이동
			
			if hor_direction < 0:
				state = STATE.LEFT
			elif hor_direction > 0:
				state = STATE.RIGHT
			# 좌우 이동에 따른 state 값 설정
		else:
		# 좌우 이동이 없다면
			velocity.x = move_toward(velocity.x, 0, SPEED)
			# 좌우 이동 정지
			
			state = STATE.IDLE
		
		if ver_direction:
		# 상하 이동 값이 있다면
			velocity.y = ver_direction * SPEED
			# 상하 이동
		else:
		# 상하 이동이 없다면
			velocity.y = move_toward(velocity.y, 0, SPEED)
			# 상하 이동 정지

		set_state(state)
		# state에 따른 설정
	
	move_and_slide()
	# 물리 이동 적용

##################################################
func _process(delta: float) -> void:
	if anim_node.animation == "explosion" and not anim_node.is_playing():
	# explosion 애니메이션이 재생 중이 아니면(재생 종료)
		anim_node.visible = false
		# 플레이어 안 보이게 가림

##################################################
func set_state(state_value: STATE) -> void:
	match state_value:
	# state에 따라
		STATE.IDLE:
			anim_node.play("idle")
		STATE.LEFT:
			anim_node.play("left")
		STATE.RIGHT:
			anim_node.play("right")
		STATE.EXPLOSION:
			anim_node.play("explosion")
		# 애니메이션 재생

##################################################
func fire_bullet() -> void:
	var bullet_instance: Node2D = PLAYER_BULLET_SCENE.instantiate()
	# bullet 인스턴스화
	bullet_instance.global_position = global_position
	# player 좌표로 설정
	get_tree().get_nodes_in_group("PlayerBullets").front().add_child(bullet_instance)
	# player 이동에 영향을 안 받도록 PlayerBullets 자식 노드로 추가
	SM.play_p_fire_effect_sound()
	# bullet 발사 효과음 재생

##################################################
func _on_attacked_player() -> void:
# player가 공격 당하면(게임 오버라면)
	GM.set_game_over(true)
	state = STATE.EXPLOSION
	call_deferred("disabled_collision")
	# 오류 방지를 위해 지연 적용
	set_state(state)
	# 각 설정 적용

##################################################
func disabled_collision() -> void:
	collision_node.disabled = true
	# collision 사용 중지 지연 호출

##################################################
func reset_game() -> void:
	SB.signal_reset_game()
	# 시그널 버스(SB) reset_game 시그널 발산
	GM.set_game_over(false)
	GM.set_enemies_count(0)
	collision_node.disabled = false
	anim_node.visible = true
	state = STATE.IDLE
	set_state(state)
	position = Vector2(180.0, 580.0)
	# 초기화 시 각 변수 초기화
