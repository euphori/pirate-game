extends KinematicBody2D

export var JUMP_HEIGHT = 940
export var ACCELERATION = 512
export var MAX_SPEED = 164
export var GRAVITY = 700
export var AIR_RESISTANCE = 0.02
export var FRICTION = .25
export var MAX_HEALTH = 100
export var ARMOR = 50



var motion = Vector2()
var invincible = false
var knockback = Vector2.ZERO
var player_detected = false
var state = IDLE
var health

onready var sprite = $Sprite
onready var player = get_node("/root/World/Player")
onready var wander_controller = $WanderController
onready var raycast = $RayCast2D

enum{
	
	IDLE,
	WANDER,
	CHASE
	
}

func _ready():
	health = MAX_HEALTH

func _physics_process(delta):
	
	motion.y += GRAVITY
	match state:
		IDLE:
			raycast.enabled = false
			if wander_controller.get_time_left() == 0:
				state = pick_random_state([IDLE,WANDER])
				wander_controller.set_wander_timer(rand_range(1,9))
			motion.x = lerp(motion.x, 0 , FRICTION)
		CHASE:

			var direction = (player.global_position - global_position)
			var distance = global_position - player.global_position
			if distance.x >= 20 or distance.x <= -20:
				motion.x += direction.x * ACCELERATION * delta
				raycast.enabled = true
			else:
				raycast.enabled = false
			motion = motion.clamped(MAX_SPEED)
		WANDER:
			raycast.enabled = true
			if wander_controller.get_time_left() == 0:
				#print("STATE: WANDER")
				state = pick_random_state([IDLE,WANDER])
				wander_controller.set_wander_timer(rand_range(1,9))
				
			var direction = global_position.direction_to(wander_controller.target_position)
			motion = motion.move_toward(direction * MAX_SPEED, ACCELERATION * delta )
			
			if global_position.distance_to(wander_controller.target_position) <= 4:
				state = pick_random_state([IDLE,WANDER])
				wander_controller.set_wander_timer(rand_range(1,9))
				
	if motion.x < 0:
		sprite.flip_h = true
		raycast.rotation_degrees = 90
	elif motion.x > 0:
		sprite.flip_h = false
		raycast.rotation_degrees = -90
	if raycast.is_colliding() and raycast.enabled:
		jump()
	motion = move_and_slide(motion)


func jump():
	motion.y -= JUMP_HEIGHT

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()


func _on_PlayerDetection_body_entered(body):
	state = CHASE
	player_detected = true


func _on_Hurtbox_area_entered(area):
	state = CHASE
	health -= 10
	if health <= 0:
		queue_free()
