extends Panel

var empty_slot = preload("res://Inventory/Textures/inv_empty_slot.png")
var filled_slot = preload("res://Inventory/Textures/inv_slot_filled.png")

var empty_style: StyleBoxTexture = null
var filled_stlye: StyleBoxTexture = null

var ItemClass = preload("res://Inventory/Item.tscn")
var item = null
var new_item = null
var slot_index
var inventory_name
var slot_type

onready var trade_ui = find_parent("TradeUI")

func _ready():
	
	empty_style = StyleBoxTexture.new()
	filled_stlye = StyleBoxTexture.new()
	empty_style.texture = empty_slot
	filled_stlye.texture = filled_slot
	
#	if randi() % 2 == 0:
#		item = ItemClass.instance()
#		add_child(item)
	refresh_slot()
	

func refresh_slot():
	if item == null and inventory_name == "Inventory":
		set("custom_styles/panel",empty_style)
	elif item != null and inventory_name == "Inventory":
		set("custom_styles/panel",filled_stlye)

func pick_from_slot():
	remove_child(item)
	
	var inventory_node = find_parent(inventory_name)
	inventory_node.add_child(item)
	item = null
	refresh_slot()
	
func put_into_slot(new_item):
	var inventory_node = find_parent(inventory_name)
	item = new_item
	item.position = Vector2(0,0)
	inventory_node.remove_child(item)
	add_child(item)
	refresh_slot()
	
func transfer_to_seller():
	var slots = trade_ui.seller_slots.get_children()
	remove_child(item)
	for i in range(slots.size()):
		if slots[i].item == null:
			slots[i].add_child(item)
			slots[i].item = item
			slots[i].item.item_holder = "shopkeep"
			break
	item = null
	refresh_slot()

func transfer_to_player():
	var slots = trade_ui.player_slots.get_children()
	remove_child(item)
	for i in range(slots.size()):
		if slots[i].item == null:
			slots[i].add_child(item)
			slots[i].item = item
			slots[i].item.item_holder = "player"
			break
	item = null
	refresh_slot()

func initialize_item(item_name, item_quantity, item_holder):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity, item_holder)
	else:
		item.set_item(item_name,item_quantity, item_holder)
	refresh_slot()
		
