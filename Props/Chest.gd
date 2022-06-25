extends StaticBody2D

onready var player_detection = $PlayerDetection
onready var sprite = $Sprite
onready var item_drop = preload("res://Items/ItemDrop.tscn")

var player_detected = false
var opened = false

func _input(event):
	if player_detected == true:
		if event.is_action_pressed("interact") and opened == false:
			sprite.frame = 1
			var drop = item_drop.instance()
			get_parent().add_child(drop)
			drop.global_position = global_position
			opened = true



func _on_PlayerDetection_body_entered(body):
	player_detected = true


func _on_PlayerDetection_body_exited(body):
	player_detected = false
