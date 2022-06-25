extends Node2D

export(int) var wander_range = 64
onready var start_position = global_position
onready var target_position = global_position


func update_target_position():
	

	var targetVector = Vector2(rand_range(-wander_range, wander_range),(0))
	target_position = start_position + targetVector

	

func get_time_left():
	return $Timer.time_left

func set_wander_timer(duration):
	$Timer.start(duration)

func _on_Timer_timeout():
	update_target_position()
