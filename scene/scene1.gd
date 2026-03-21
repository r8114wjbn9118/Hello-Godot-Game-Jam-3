extends Node2D

@export var level:Level

@onready var card_deck = %card_deck

var card_tscn = preload("res://card/base.tscn")
var top_card:Card = null

enum STATE {
	LOAD,
	START,
	ANIM,
	USERACTION,
	END
}
var state = STATE.LOAD:
	set(value):
		printt(STATE.keys().get(state), STATE.keys().get(value))
		state = value

func _ready() -> void:
	init_card_deck()
	start()

func _input(event: InputEvent) -> void:
	if state == STATE.USERACTION and top_card:
		if event is InputEventMouseMotion:
			top_card.global_position = event.position
		elif event is InputEventMouseButton and event.button_mask == 0:
			var w = get_viewport().size.x / 3
			if top_card.global_position.x < w:
				if top_card.start_left():
					exit_card(true)
			elif top_card.global_position.x > w * 2:
				if top_card.start_right():
					exit_card(false)

func init_card_deck():
	for child in card_deck.get_children():
		child.queue_free()

	for i in range(4):
		var card = card_tscn.instantiate()
		card_deck.add_child(card)

func start():
	state = STATE.START
	next_card()

func next_card():
	var next = level.card_deck.pop_front()
	if next:
		print("next:", next.show_name)
		state = STATE.ANIM
		top_card = card_deck.get_child(-1)
		top_card.data = next
		print(top_card)
		top_card.anim_finished.connect(start_user_action, ConnectFlags.CONNECT_ONE_SHOT)
		top_card.open()
	else:
		state = STATE.END

func start_user_action():
	state = STATE.USERACTION

func exit_card(to_left):
	var tween = create_tween()
	var pos = Vector2(
		top_card.global_position.x + get_viewport().size.x / 3 * (-1 if to_left else 1),
		top_card.global_position.y
		)
	tween.tween_property(top_card, "global_position", pos, 1)
	tween.tween_callback(reset_top_card_pos)
	tween.tween_callback(next_card)

func reset_top_card_pos():
	if top_card:
		card_deck.move_child(top_card, 1)
		top_card.reset()
	next_card()
