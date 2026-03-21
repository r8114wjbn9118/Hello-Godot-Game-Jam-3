extends Node2D

@export var level:Level

@onready var card_deck = %card_deck

var top_card:Card = null

enum STATE {
	LOAD,
	START,
	ANIM,
	USER_ACTION,
	END
}
var state = STATE.LOAD

var card_max_rotation = 30

func _ready() -> void:
	init_card_deck()
	start()

func _input(event: InputEvent) -> void:
	if state == STATE.USER_ACTION and top_card:
		var effective_width = get_viewport().size.x / 3
		if event is InputEventMouseMotion:
			if event.position.x < effective_width:
				top_card.rotation_degrees = -card_max_rotation
			elif event.position.x > effective_width * 2:
				top_card.rotation_degrees = card_max_rotation
			else:
				top_card.rotation_degrees = card_max_rotation * 2 * (event.position.x - effective_width) / effective_width - card_max_rotation
		elif event is InputEventMouseButton and event.button_mask == 0:
			if top_card.rotation_degrees == -card_max_rotation:
				if top_card.can_start_left():
					Data.set_card_action(-1)
					exit_card(false)
			elif top_card.rotation_degrees == card_max_rotation:
				if top_card.can_start_right():
					Data.set_card_action(1)
					exit_card(true)

func init_card_deck():
	for child in card_deck.get_children():
		child.queue_free()

	for i in range(2):
		var card:Card = Data.CARD.instantiate()
		card.anim_finished.connect(start_user_action)
		card_deck.add_child(card)

func start():
	state = STATE.START
	next_card()

func end():
	state = STATE.END
	pass

func next_card():
	var next = level.card_deck.pop_front()
	if next:
		state = STATE.ANIM
		top_card = card_deck.get_child(-1)
		top_card.data = next
		top_card.open()
	else:
		end()

func start_user_action(anim_name):
	if anim_name == "open":
		state = STATE.USER_ACTION

func exit_card(to_right):
	state = STATE.ANIM
	var tween = create_tween()
	var pos = Vector2(
		top_card.global_position.x + get_viewport().size.x * (1 if to_right else -1),
		top_card.global_position.y
		)
	tween.tween_property(top_card, "global_position", pos, 1)
	tween.tween_callback(reset_top_card_pos)
	tween.tween_callback(top_card.start_action)

func reset_top_card_pos():
	if top_card:
		card_deck.move_child(top_card, 0)
		top_card.reset()
