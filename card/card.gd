@tool
class_name Card
extends Node2D

signal anim_finished

@export var data:CardData:
	set(value):
		data = value
		update_data()
var default_back_image:Texture2D = load("res://image/卡牌/backtime.png")

func update_data():
	if not data:
		return

	if %front:
		%front.texture = data.front_image if data.front_image else null
	if %back:
		%back.texture = data.back_image if data.back_image else default_back_image

var is_open:bool = false

func _ready() -> void:
	update_data()

func start_action():
	var action_type = Data.card_action
	var action_list
	if action_type == "left":
		action_list = data.left_action.duplicate_deep()
	elif action_type == "right":
		action_list = data.right_action.duplicate_deep()
	elif action_type == "appear":
		action_list = data.appear_action.duplicate_deep()
	Action.start_action_list(action_type, action_list)

func reset():
	position = Vector2(0, 0)
	rotation = 0
	%AnimationPlayer.play("RESET")
	is_open = false

func open():
	if not is_open:
		%AnimationPlayer.play("open")
		is_open = true

func close():
	if is_open:
		%AnimationPlayer.play_backwards("open")
		is_open = false

func switch():
	if is_open:
		close()
	else:
		open()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_finished.emit(anim_name)
