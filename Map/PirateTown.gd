extends Area2D

onready var player_ship = get_node("/root/Map/ScrollContainer/Container/PlayerShip")



func _on_PirateTown_pressed():
	player_ship.target_position = self.global_position


