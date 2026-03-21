class_name Card
extends Node2D

signal anim_finished

@export var data:CardData:
	set(value):
		data = value
		update_data()
var default_back_image:Texture2D = load("res://image/卡牌/backtime.png")

func update_data():
	if %front:
		%front.texture = data.front_image if data.front_image else null
	if %back:
		%back.texture = data.back_image if data.back_image else default_back_image

enum STATE { CLOSE, OPEN, }
var current_state:STATE = STATE.CLOSE

func _ready() -> void:
	update_data()

func start_left():
	print(data.left_desc)
	return true
func start_right():
	print(data.right_desc)
	return true

func reset():
	position = Vector2(0, 0)
	%AnimationPlayer.play("RESET")

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
	printt(self, anim_name)
	anim_finished.emit()
