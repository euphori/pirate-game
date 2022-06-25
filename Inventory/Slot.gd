extends Panel

var empty_slot = preload("res://Inventory/Textures/inv_slot.png")
var tier1_slot = preload("res://Inventory/Textures/tier1_slot.png")

var empty_style: StyleBoxTexture = null
var tier1_style: StyleBoxTexture = null

var ItemClass = preload("res://Inventory/Item.tscn")
var item = null
var new_item = null


func _ready():
	
	empty_style = StyleBoxTexture.new()
	tier1_style = StyleBoxTexture.new()
	empty_style.texture = empty_slot
	tier1_style.texture = tier1_slot
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refresh_slot()
	

func refresh_slot():
	if item == null:
		set("custom_styles/panel",empty_style)
	else:
		set("custom_styles/panel",tier1_style)

func pick_from_slot():
	remove_child(item)
	var inventory_node = find_parent("Inventory")
	inventory_node.add_child(item)
	item = null
	refresh_slot()
	
func put_into_slot(new_item):
	item = new_item
	item.position = Vector2(0,0)
	var inventory_node = find_parent("Inventory")
	inventory_node.remove_child(item)
	add_child(item)
	refresh_slot()
	
func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	else:
		item.set_item(item_name,item_quantity)
	refresh_slot()
		
