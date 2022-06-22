extends KinematicBody2D

export var JUMP_HEIGHT = 240
export var ACCELERATION = 512
export var MAX_SPEED = 164
export var GRAVITY = 700
export var AIR_RESISTANCE = 0.02
export var FRICTION = .25
export var HUNGER_TIMER = 10
export var MAX_HEALTH = 100

var UP = Vector2(0,-1)
var motion = Vector2.ZERO

onready var state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta):
	
	motion.y += GRAVITY * delta
	
	var input_vector = Vector2.ZERO
	input_vector = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	flip()
	
	if input_vector != 0:
		state_machine.travel("walk")
		motion.x += input_vector* ACCELERATION * delta
		motion.x = clamp(motion.x , -MAX_SPEED , MAX_SPEED)
		
	if is_on_floor():
		if input_vector == 0:
			state_machine.travel("idle")
			motion.x = lerp(motion.x, 0 , FRICTION )
		
		if Input.is_action_just_pressed("jump"):
			state_machine.travel("jump")
			motion.y -= JUMP_HEIGHT 
	
	if !is_on_floor():
		state_machine.travel("jump")
	
	else:
			if input_vector == 0:
				motion.x = lerp(motion.x, 0 , AIR_RESISTANCE )
	
	motion = move_and_slide(motion, UP)

func flip():
	var direction = sign(get_global_mouse_position().x - global_position.x)
	if direction < 0:
		$Sprite.set_flip_h(true)
		
	else:
		$Sprite.set_flip_h(false)
