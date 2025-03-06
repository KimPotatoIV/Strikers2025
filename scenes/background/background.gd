extends Node2D

##################################################
const MOVING_SPEED: float = 50.0
# 배경 이미지 이동 속도

var bg_sprite_1_node: Sprite2D
var bg_sprite_2_node: Sprite2D
# 배경 이미지 노드들 선언

var wall_node: StaticBody2D
# 플레이어 이동 제한을 위한 벽 노드 선언

##################################################
func _ready() -> void:
	bg_sprite_1_node = $BGSprite1
	bg_sprite_2_node = $BGSprite2
	wall_node = $Wall
	# 각 노드 설정
	
	wall_node.set_collision_layer_value(1, true)
	# 벽 노드의 Collision Layer 설정
	# Player Collision Mask가 Layer1이 켜져 있음
	
	z_index = -10
	# 그리기 순서 설정

##################################################
func _process(delta: float) -> void:
	bg_sprite_1_node.position.y += MOVING_SPEED * delta
	bg_sprite_2_node.position.y += MOVING_SPEED * delta
	# 각 이미지 위에서 아래로 이동
	
	if bg_sprite_1_node.position.y >= 1090.0:
		bg_sprite_1_node.position.y = bg_sprite_2_node.position.y - 900.0
	if bg_sprite_2_node.position.y >= 1090.0:
		bg_sprite_2_node.position.y = bg_sprite_1_node.position.y - 900.0
	# 각 이미지가 일정 위치 이상 벗어나면 다른 이미지 상단으로 이동
	# 무한 배경 스크롤링
