extends KinematicBody2D

export var GRAVITY = 200
export var ACCELERATION = 700
export var MAX_SPEED = 300

var motion = Vector2.ZERO
var item_name
var being_picked_up = false


onready var player = get_node("/root/World/Player")
onready var sprite = $Sprite

func _ready():
	randomize()
	var options = ["Orange","Flintlock Pistol", "Sabre"]
	var rand_index:int = randi() % options.size()
	item_name = options[rand_index]
	sprite.texture = load("res://Items/Icons/" + item_name + ".png")


func _physics_process(delta):
	
	
	if being_picked_up == false:
		motion.y += GRAVITY * delta
	else:
		var direction = global_position.direction_to(player.global_position)
		motion = motion.move_toward( direction * MAX_SPEED , ACCELERATION * delta)
		
		var distance =  global_position.distance_to(player.global_position)
		if distance < 4:
			PlayerInventory.add_item(item_name, 1)
			queue_free()
		
	motion = move_and_slide(motion)


func pick_up_item(body):
	player = body
	being_picked_up = true
