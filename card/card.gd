class_name Card
extends Node2D

@export var data:CardData:
	set(value):
		data = value
		update_data()

func update_data():
	if %front and data.front_image:
		%front.texture = data.front_image
	if %back and data.back_image:
		%back.texture = data.back_image

enum STATE {
	CLOSE,
	OPEN,
}
var current_state:STATE = STATE.CLOSE

func _ready() -> void:
	update_data()

var t = 0
func _process(delta: float) -> void:
	t += delta
	if t > 2:
		match current_state:
			STATE.CLOSE:
				open()
			STATE.OPEN:
				close()
		t = 0

func open():
	if current_state != STATE.OPEN:
		%AnimationPlayer.play("open")
		current_state = STATE.OPEN

func close():
	if current_state != STATE.CLOSE:
		%AnimationPlayer.play_backwards("open")
		current_state = STATE.CLOSE
