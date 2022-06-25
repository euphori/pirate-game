extends Area2D


var items_in_range = {}




func _on_PickupZone_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	items_in_range[body] = body


func _on_PickupZone_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if items_in_range.has(body):
		items_in_range.erase(body)
