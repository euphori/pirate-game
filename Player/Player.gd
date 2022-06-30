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
var current_weapon = null

onready var weapon_position = $WeaponPosition
onready var state_machine = $AnimationTree.get("parameters/playback")
onready var sabre = preload("res://Weapons/Sabre.tscn")
onready var pickup_zone = $PickupZone
onready var hat = $Sprite/Hat

func _ready():
	instance_weapon(sabre)

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
		hat.set_flip_h(true)
		weapon_position_update()
		weapon_position.position.x = -8
		
	else:
		$Sprite.set_flip_h(false)
		hat.set_flip_h(false)
		weapon_position_update()
		weapon_position.position.x = 7

		
func instance_weapon(weaponName):
	var weapon = weaponName.instance()
	add_child(weapon)
	current_weapon = weapon
	weapon.global_position = weapon_position.global_position

func weapon_position_update():
	if current_weapon != null:
		current_weapon.global_position = weapon_position.global_position

func _input(event):
	if event.is_action_pressed("interact"):
		if pickup_zone.items_in_range.size() > 0:
			var pickup_item = pickup_zone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			pickup_zone.items_in_range.erase(pickup_item)
