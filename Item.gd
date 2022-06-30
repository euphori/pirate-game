extends Node2D

var item_name
var item_quantity
var item_holder

onready var texture_rect = $TextureRect
onready var label = $Label


#func _ready():
#	randomize()
#	var rng = randi() % 3
#	if rng == 0:
#		item_name = "Sabre"
#	elif  rng == 1:
#		item_name = "Flintlock Pistol"
#	else:
#		item_name = "Orange"
#
#	texture_rect.texture = load("res://Items/Icons/" + item_name + ".png")
#	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
#
#	if stack_size == 1:
#		label.visible = false
#	else:
#		label.text = String(item_quantity)
		
func set_item(nm , qt, ih):
	item_name = nm
	item_quantity = qt
	item_holder = ih
	texture_rect.texture = load("res://Items/Icons/" + item_name + ".png")
	var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1: 
		label.visible = false
	else:
		label.visible = true
		label.text = String(item_quantity)
	
func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	label.text = String(item_quantity)
	
func subtract_item_quantity(amount_to_subtract):
	item_quantity -= amount_to_subtract
	label.text = String(item_quantity)
