extends KinematicBody2D

export var ACCELERATION = 3000
export var MAX_SPEED = 164


var motion = Vector2.ZERO
var target_position = Vector2.ZERO


onready var sprite = $Sprite
onready var game_data = SaveFile.game_data

func _ready():
	print(game_data.ship_position)
	global_position = game_data.ship_position

func _physics_process(delta):

	var direction = target_position - global_position
	
	if target_position != Vector2.ZERO:
		motion = direction.normalized() * ACCELERATION * delta
		
		if direction.length() < 3:
			return
			
	sprite.flip_h = motion.x < 0
	motion = move_and_slide(motion)
	
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_RIGHT:
			target_position = get_global_mouse_position()
			
	if event.is_action_pressed("map") or event.is_action_pressed("esc"):
		get_tree().change_scene("res://World.tscn")


func _on_Area2D_body_entered(body):
	print("ENTERED")
	game_data.ship_position = global_position
	get_tree().change_scene("res://Island/PirateIsland.tscn")
	
