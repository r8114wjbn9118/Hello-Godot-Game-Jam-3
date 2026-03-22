class_name ChapterScene
extends Node2D

signal update_text_finished
signal show_card_finished

@export var default_level:int
@export var new_card_udpate_interval:float = 0.05

@onready var card_deck = %card_deck

var top_card:Card = null

var new_card_desc
var update_desc_timer:float = 0.0
var update_desc_index:int = 0

var new_card_opacity = null

enum STATE {
	LOAD,
	START,
	ANIM,
	USER_ACTION,
	END
}
var state:STATE = STATE.LOAD

var card_max_rotation:float = 30

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

func _process(delta: float) -> void:
	update_text(delta)

func set_text(text:String):
	update_desc_index = 0
	update_desc_timer = 0

	new_card_desc = text.split()
	%card_desc.text = ""
	%card_desc.modulate.a = 1

func update_text(delta: float):
	if new_card_desc:
		update_desc_timer = (update_desc_timer + delta)
		while update_desc_timer > new_card_udpate_interval:
			update_desc_timer -= new_card_udpate_interval
			%card_desc.text += new_card_desc[update_desc_index]
			update_desc_index += 1
			if update_desc_index >= len(new_card_desc):
				new_card_desc = null
				update_desc_index = 0
				update_desc_timer = 0
				update_text_finished.emit(self)



func init():
	%background.texture = Data.current_level.background
	
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
	
	%left_shadow.modulate = Color(data.left_shadow_color, 0)
	%left_desc.text = data.left_desc
	%left_desc.modulate = Color(data.left_desc_color, 0)

	%right_shadow.modulate = Color(data.right_shadow_color, 0)
	%right_desc.text = data.right_desc
	%right_desc.modulate = Color(data.right_desc_color, 0)
	
	%card_desc["theme_override_colors/font_color"] = data.desc_color
	%card_desc["theme_override_colors/font_outline_color"] = data.desc_outline_color
	set_text(data.description)

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

	var weight = t / 3
	%left_shadow.modulate.a = lerp(%left_shadow.modulate.a, 0.0, weight)
	%left_desc.modulate.a = lerp(%left_desc.modulate.a, 0.0, weight)
	%right_shadow.modulate.a = lerp(%right_shadow.modulate.a, 0.0, weight)
	%right_desc.modulate.a = lerp(%right_desc.modulate.a, 0.0, weight)
	%card_desc.modulate.a = lerp(%card_desc.modulate.a, 0.0, weight)

func reset_top_card_pos():
	if top_card:
		card_deck.move_child(top_card, 0)
		top_card.reset()


func change_card_opacity(opacity:float):
	var tween = create_tween()
	var new_color = Color(1,1,1,opacity)
	tween.tween_property(%card_deck, "modulate", new_color, 1)
	tween.tween_callback(show_card_finished.emit)
func show_card():
	change_card_opacity(1)
func hide_card():
	change_card_opacity(0)



func _on_card_anim_finished(anim_name:String):
	if anim_name == "open":
		top_card.start_appear_action()

func _on_card_action_finished(action):
	if action == "appear":
		update_screen_data()
		start_user_action()
	else:
		next_card()
