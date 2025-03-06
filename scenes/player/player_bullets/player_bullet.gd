extends Area2D

##################################################
const MOVING_SPEED: float = 500.0
# 이동 속도

var sprite_node: Sprite2D
var anim_node: AnimatedSprite2D
# 각 노드 초기화. anim_node는 터지는 애니메이션 재생 노드
var hit_boss: bool = false
# Boss에 bullet이 충돌 시 그 자리에서 애니메이션 재생 후 없애기 위해 확인하는 변수

##################################################
func _ready() -> void:
	sprite_node = $Sprite2D
	anim_node = $AnimatedSprite2D
	anim_node.visible = false
	# 각 노드 초기화
	
	add_to_group("PlayerBullet")
	# PlayerBullet 그룹에 추가
	z_index = -1
	# 그리기 순서 설정
	
	connect("area_entered", Callable(self, "_on_area_entered"))
	# area_entered 시 _on_area_entered 함수 실행 연결
	anim_node.connect("animation_finished", Callable(self, "_on_animation_finished"))
	#animation_finished 시 _on_animation_finished 함수 실행 연결

##################################################
func _process(delta: float) -> void:
	if not hit_boss:
	# Boss와 충돌한 게 아니라면
		position.y -= MOVING_SPEED * delta
		# 아래에서 위로 이동
	
	if position.y <= -10:
	# 화면 일정 거리 이상 밖으로 벗어나면
		queue_free()
		# 노드 삭제

##################################################
func _on_animation_finished() -> void:
	queue_free()
# 애니메이션이 끝나도 노드 삭제

##################################################
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy"):
	# area가 Enemy 그룹이면
		queue_free()
		# 노드 삭제
	elif area.is_in_group("Boss"):
	# area가 Boss 그룹이면
		anim_node.visible = true
		anim_node.play("explosion")
		sprite_node.visible =  false
		hit_boss = true
		# explosion 애니메이션 재생 및 각 노드 설정
