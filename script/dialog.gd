extends Control

signal update_text_finished

@export var udpate_interval:float = 0.05

@export var default_color:Color = Color.BLACK
@export var default_outline_color:Color = Color(1.0, 1.0, 1.0, 0.3)

@export var default_text_size:int = 40

var character = {
	"A": {
		"color": Color("#ae6060"),
		#"outline_color": Color.BLUE
	},
	"B": {
		"color": Color("#93b8b9"),
		#"outline_color": Color.RED
	}
}

var new_text_list = null
var update_timer:float = 0.0
var update_index:int = 0

func _ready() -> void:
	init()

func _process(delta: float) -> void:
	update_text(delta)

func init():
	new_text_list = null
	update_timer = 0.0
	update_index = 0

func set_default():
	set_text("")
	set_text_size(default_text_size)

func set_color(color):
	%text["theme_override_colors/font_color"] = color if color is Color else default_color
func set_outline_color(color):
	%text["theme_override_colors/font_outline_color"] = color if color is Color else default_outline_color
func set_char_color(key:String):
	var dict = character.get(key)
	if dict:
		set_color(dict.get("color"))
		set_outline_color(dict.get("outline_color"))

func set_text(
	text:String,
	color:Color = default_color,
	outline_color:Color = default_outline_color
):
	set_text_only(text)

	set_color(color)
	set_outline_color(outline_color)

func set_text_only(text:String):
	init()
	new_text_list = text.split()

	%text.text = ""
	%text.modulate.a = 1

func set_char_text(text:String, key:String):
	var dict = character.get(key)
	if dict:
		set_text(text, dict.get("color"), dict.get("outline_color"))
	else:
		set_text(text)



func set_text_size(text_size = default_text_size):
	if not text_size or text_size <= 0:
		text_size = default_text_size
	%text["theme_override_font_sizes/font_size"] = text_size



func update_text(delta: float):
	if new_text_list:
		update_timer = (update_timer + delta)
		while update_timer > udpate_interval:
			update_timer -= udpate_interval
			%text.text += new_text_list[update_index]
			update_index += 1
			if update_index >= len(new_text_list):
				init()
				update_text_finished.emit()



func exit_card_anim(weight):
	%text.modulate.a = lerp(%text.modulate.a, 0.0, weight)
