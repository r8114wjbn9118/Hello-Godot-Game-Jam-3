extends Node2D

@export var default_level:int

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
	if not Data.current_level:
		Action.chapter_restart(default_level)
	init()
	start()

func _input(event: InputEvent) -> void:
	if state == STATE.USER_ACTION and top_card:
		var effective_width = get_viewport().size.x / 3
		if event is InputEventMouseMotion:
			var distance
			if event.position.x < effective_width:
				distance = -1
			elif event.position.x > effective_width * 2:
				distance = 1
			else:
				distance = (card_max_rotation * 2 * (event.position.x - effective_width) / effective_width - card_max_rotation) / card_max_rotation
			update_screen_effect(distance)
		elif event is InputEventMouseButton and event.button_mask == 0:
			var action = ""
			if top_card.rotation_degrees == -card_max_rotation:
				action = "left"
			elif top_card.rotation_degrees == card_max_rotation:
				action = "right"

			if action:
				Data.set_card_action(action)
				start_exit_card()

func init():
	%left_shadow.modulate.a = 0
	%right_shadow.modulate.a = 0
	%left_desc.text = ""
	%right_desc.text = ""
	%card_desc.text = ""
	
	for child in card_deck.get_children():
		child.queue_free()

	for i in range(2):
		var card:Card = Data.CARD.instantiate()
		card.anim_finished.connect(_on_card_anim_finished)
		card.action_finished.connect(_on_card_action_finished)
		card_deck.add_child(card)

func start():
	state = STATE.START
	next_card()

func end():
	state = STATE.END
	pass

func next_card():
	var next = Data.current_level.get_next_card()
	if next:
		state = STATE.ANIM
		top_card = card_deck.get_child(-1)
		top_card.data = next
		top_card.open()
	else:
		end()

func update_screen_effect(distance):
	top_card.rotation_degrees = distance * card_max_rotation
	
	%left_shadow.modulate.a = clamp(-distance, 0, 1)
	%left_desc.modulate.a = clamp(-distance, 0, 1)
	
	%right_shadow.modulate.a = clamp(distance, 0, 1)
	%right_desc.modulate.a = clamp(distance, 0, 1)

func update_screen_data():
	var data = top_card.data
	
	%left_shadow.modulate = data.left_shadow_color
	%left_desc.text = data.left_desc
	%left_desc.modulate = Color(data.left_desc_color, 0)

	%right_shadow.modulate = data.right_shadow_color
	%right_desc.text = data.right_desc
	%right_desc.modulate = Color(data.right_desc_color, 0)
	
	%card_desc.text = data.description
	%card_desc.modulate = data.desc_color

func start_user_action():
	state = STATE.USER_ACTION

func start_exit_card():
	state = STATE.ANIM
	var tween = create_tween()
	tween.tween_method(exit_card_anim, 0.0, 1.0, 1.0)
	tween.tween_callback(reset_top_card_pos)
	tween.tween_callback(top_card.start_action)

func exit_card_anim(t):
	var pos = get_viewport().size.x / 100
	if top_card.rotation < 0:
		pos = -pos
	top_card.global_position.x += pos
	%left_shadow.modulate.a = lerp(%left_shadow.modulate.a, 0.0, t / 10)
	%left_desc.modulate.a = lerp(%left_desc.modulate.a, 0.0, t / 10)
	%right_shadow.modulate.a = lerp(%right_shadow.modulate.a, 0.0, t / 10)
	%right_desc.modulate.a = lerp(%right_desc.modulate.a, 0.0, t / 10)
	%card_desc.modulate.a = lerp(%card_desc.modulate.a, 0.0, t / 10)

func reset_top_card_pos():
	if top_card:
		card_deck.move_child(top_card, 0)
		top_card.reset()



func _on_card_anim_finished(anim_name:String):
	if anim_name == "open":
		top_card.start_appear_action()

func _on_card_action_finished(action):
	if action == "appear":
		update_screen_data()
		start_user_action()
	else:
		next_card()
