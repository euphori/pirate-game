extends CanvasLayer

onready var inventory = $Inventory

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.visible = !inventory.visible
		inventory.initialize_inventory()
