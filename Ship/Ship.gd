extends KinematicBody2D


var player_detected = false


onready var sail_now = $Sail
onready var camera = get_node("/root/World/Player/Camera2D")
onready var interact_label = $InteractLabel

func _input(event):
	if event.is_action_pressed("interact") and player_detected :
		camera.in_dialogue = true
		sail_now.visible = true
		interact_label.visible = false
		
	if sail_now.visible:
		if event.is_action_pressed("1"):
			get_tree().change_scene("res://Map/Map.tscn")
		
func _on_PlayerDetection_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	player_detected = true
	interact_label.visible = true
	
	
func _on_PlayerDetection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	player_detected = false
	sail_now.visible = false
	camera.in_dialogue = false
	interact_label.visible = false
	

