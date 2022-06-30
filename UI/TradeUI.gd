extends Control


var holding_item = null
var total_cost = 0

onready var label_total = $TotalLabel
onready var label_player_gold = $PlayerGoldLabel
onready var player_container = $PlayerContainer
onready var seller_container = $SellerContainer
onready var seller_slots = $SellerContainer/SellerSlots
onready var player_slots = $PlayerContainer/PlayerSlots
func _ready():
	label_player_gold.text = str(PlayerInventory.gold)
