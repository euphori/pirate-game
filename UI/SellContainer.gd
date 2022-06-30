extends ScrollContainer

const SlotClass = preload("res://Inventory/Slot.gd")
onready var inventory_slots = $SellSlots
onready var trade_ui = get_parent()
onready var player_inventory = get_node("/root/World/Player/UserInterface/Inventory")

var valid_holder = ["player", "none"]

func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].inventory_name = "TradeUI"


func remove_items():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			PlayerInventory.remove_item(slots[i])
			print(PlayerInventory.inventory)
			if PlayerInventory.inventory.has(i):
				PlayerInventory.update_slot_visual(i, PlayerInventory.inventory[i][0],PlayerInventory.inventory[i][1])
			slots[i].transfer_to_seller()


	trade_ui.label_total.text = str(trade_ui.total_cost)



func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if trade_ui.holding_item != null:
				if valid_holder.has(trade_ui.holding_item.item_holder):
					if !slot.item: #Place holding item to slot
						left_click_empty_slot(slot)
						update_total(slot.item.item_name, "add", slot)
					else: #swap holding item to slot
						if trade_ui.holding_item.item_name != slot.item.item_name:
							left_click_different_item(event, slot)
							
						else:
							left_click_same_item(slot)
			elif slot.item:
				change_holder(slot, "none")
				left_click_not_holding_item(slot)
		
func _input(event):

	if trade_ui.holding_item:
		trade_ui.holding_item.global_position = get_global_mouse_position()
	
func update_total(item_name, method, slot: SlotClass):
	var item_value = int(JsonData.item_data[item_name]["Value"])
	if method == "subtract":
		trade_ui.total_cost -= item_value * slot.item.item_quantity
	else:
		trade_ui.total_cost += item_value * slot.item.item_quantity
	trade_ui.label_total.text = str(trade_ui.total_cost)


func left_click_empty_slot(slot: SlotClass):

	slot.put_into_slot(trade_ui.holding_item)
	change_holder(slot, "seller")
	trade_ui.holding_item = null
	
	
	
func left_click_different_item(event: InputEvent, slot: SlotClass):

	var temp_item = slot.item
	slot.pick_from_slot()
	temp_item.global_position = event.global_position
	slot.put_into_slot(trade_ui.holding_item)
	trade_ui.holding_item = temp_item

func left_click_same_item(slot: SlotClass):
	var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity
	if able_to_add >= trade_ui.holding_item.item_quantity:
		slot.item.add_item_quantity(trade_ui.holding_item.item_quantity)
		trade_ui.holding_item.queue_free()
		trade_ui.holding_item = null
	else:
		slot.item.add_item_quantity(able_to_add)
		trade_ui.holding_item.subtract_item_quantity(able_to_add)

func left_click_not_holding_item(slot: SlotClass):
	trade_ui.holding_item = slot.item
	update_total(slot.item.item_name, "subtract", slot)
	slot.pick_from_slot()
	trade_ui.holding_item.global_position = get_global_mouse_position()

func add_player_gold():
	PlayerInventory.gold += trade_ui.total_cost 
	trade_ui.label_player_gold.text = str(PlayerInventory.gold)

func change_holder(slot: SlotClass, item_holder):
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		if slots[i].item != null:
			slots[i].item.item_holder = item_holder
	

func _on_ConfirmButton_button_down():
	print("SELL")
	
	remove_items()
	add_player_gold()
	trade_ui.total_cost = 0
	trade_ui.label_total.text = str(trade_ui.total_cost)
