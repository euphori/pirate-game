extends Area2D


onready var interact_label = $InteractLabel
onready var player = get_node("/root/World/Player")
onready var camera = get_node("/root/World/Player/Camera2D")
onready var speech_text = $SpeechBubble/Label
onready var speech_bubble = $SpeechBubble
onready var trade_ui = $CanvasLayer/TradeUI

var player_detected = false

func _ready():
	speech_text.text = "ahoy, matey"


func _input(event):
	if event.is_action_pressed("interact") and player_detected:
		camera.in_dialogue = true
		speech_bubble.visible = true
		interact_label.visible = false
		trade_ui.visible = true

func _on_Shopkeeper_body_entered(body):
	player_detected = true
	interact_label.visible = true


func _on_Shopkeeper_body_exited(body):
	interact_label.visible = false
	camera.in_dialogue = false
	speech_bubble.visible = false
	trade_ui.visible = false
	player_detected = false
