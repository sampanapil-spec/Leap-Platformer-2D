extends CharacterBody2D
class_name Player

@export var max_speed: float = 180
@export var jump_force: float = -450
@export var max_jump: int = 2
@export var gravity: float = 1600

@onready var anim_sprite = $AnimatedSprite2D
@onready var ray_cast_2d = $RayCast2D

var jumps_left: int
var move_direction: int = 1
var can_move: bool = true

func _physics_process(delta: float) -> void:
	if not can_move:
		return
	
	handle_movement()
	handle_jump_input() 
	handle_gravity(delta)
	handle_wall_collisions()
	
	move_and_slide()

func handle_movement() -> void:
	velocity.x = move_direction * max_speed
	if is_on_floor():
		anim_sprite.play("run")
		jumps_left = max_jump

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_wall_collisions() -> void:
	if not ray_cast_2d.is_colliding():
		return
	
		velocity.y = 50 
		anim_sprite.play("fall")
	
	if is_on_floor():
		change_direction()

func handle_jump_input() -> void:
	if Input.is_action_just_pressed("tap"):
		if ray_cast_2d.is_colliding():
			change_direction()      
			velocity.y = jump_force 
			jumps_left = max_jump - 1 
			anim_sprite.play("jump")
			
		elif jumps_left > 0:
			velocity.y = jump_force 
			jumps_left -= 1
			
			if jumps_left < (max_jump - 1):
				anim_sprite.play("double_jump")
			else:
				anim_sprite.play("jump")

func change_direction() -> void:
	move_direction *= -1
	scale.x *= -1

func player_died() -> void:
	can_move = false
	velocity = Vector2.ZERO
	anim_sprite.play("dead")
