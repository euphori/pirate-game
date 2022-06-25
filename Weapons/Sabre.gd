extends StaticBody2D


onready var animation_player = $AnimationPlayer
onready var player = get_node("/root/World/Player")



func _physics_process(delta):
	
	var mouse_angle = global_position.angle_to_point(get_global_mouse_position())
	var direction = sign(get_global_mouse_position().x - player.global_position.x)
	if direction > 0:
		scale.x = 1
		#look_at(get_global_mouse_position())
		rotation_degrees = rad2deg(mouse_angle) + 180
	else:
		scale.x = -1
		#look_at(get_global_mouse_position())
		rotation_degrees =  rad2deg(mouse_angle) 

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
				animation_player.play("down_slash")
				yield(animation_player, "animation_finished")
				$Sprite.rotation_degrees = 0
