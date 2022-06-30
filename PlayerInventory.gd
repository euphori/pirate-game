extends Node


const NUM_INVENTORY_SLOTS = 20
const SlotClass = preload("res://Inventory/Slot.gd")
const ItemClass = preload("res://Item.gd")

var gold = 500

var inventory = {
	
	0:["Orange", 98], # --> slot index: [item_name , item_quantity]
	1:["Sabre" , 1],
	2:["Flintlock Pistol", 1],
	3:["Orange", 40]
}

func add_item(item_name, item_quantity):
	for item in inventory:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			
			if able_to_add >= item_quantity :
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
	
	#item doesnt exist in inventory yet, so add it on an empty slot
	
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i , inventory[i][0], inventory[i][1])
			return

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot:SlotClass):
	inventory.erase(slot.slot_index)

	
func add_item_quantity(slot:SlotClass , quantity_to_add):
	inventory[slot.slot_index][1] += quantity_to_add

func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/World/Player/UserInterface/Inventory/ScrollContainer/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity, "player")
	else:
		slot.initialize_item(item_name, new_quantity, "player")
