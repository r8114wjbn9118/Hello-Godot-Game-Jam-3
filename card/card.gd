@tool
class_name Card
extends Node2D

signal anim_finished
signal action_finished

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

enum STATE {
	CLOSE,
	OPEN,
}
var current_state:STATE = STATE.CLOSE

func _ready() -> void:
	update_data()

func can_action(action_dict:Dictionary):
	return not action_dict.is_empty()

func start_action():
	var action = Data.card_action
	if action == "left":
		run_action(data.left_action)
	elif action == "right":
		run_action(data.right_action)
	Data.set_card_action()
	action_finished.emit(action)

func start_appear_action():
	run_action(data.appear_action)
	action_finished.emit("appear")

func run_action(action_dict:Dictionary):
	if can_action(action_dict):
		for action in action_dict.keys():
			Action.call(action, action_dict.get(action))

func reset():
	position = Vector2(0, 0)
	rotation = 0
	%AnimationPlayer.play("RESET")
	current_state = STATE.CLOSE

func open():
	if current_state != STATE.OPEN:
		%AnimationPlayer.play("open")
		current_state = STATE.OPEN

func close():
	if current_state != STATE.CLOSE:
		%AnimationPlayer.play_backwards("open")
		current_state = STATE.CLOSE

func switch():
	match current_state:
		STATE.CLOSE:
			open()
		STATE.OPEN:
			close()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_finished.emit(anim_name)
