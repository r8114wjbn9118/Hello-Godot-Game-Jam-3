extends Node

signal action_finished
signal action_list_finished

var sleep_timer:float = 0.0


var action_type = ""
var action_list = []

func init_action_data():
	action_type = ""
	action_list = []


func start_action_list(type:String, list:Array = []):
	action_type = type
	action_list = list

	run_action_list()

func run_action_list():
	if action_type:
		if not action_list.is_empty():
			var action = action_list.pop_front()
			Action.call(action[0], action[1])
		else:
			action_list_finished.emit()
			init_action_data()

func action_finish(action_name:String):
	action_finished.emit(action_name)
	run_action_list()



func get_chapter_scene():
	return Data.chapter_scene

func _process(delta: float) -> void:
	if sleep_timer > 0.0:
		sleep_timer = max(sleep_timer - delta, 0.0)
		if sleep_timer == 0.0:
			action_finish("sleep")


func goto(target:String):
	var scene = Data.SCENE.get(target)
	if scene:
		get_tree().change_scene_to_file(scene)
		Effect.switch_opacity(false)
	else:
		printerr("Scene '{0}' not exists".format(target))
	action_finish("goto")

func goto_chapter(n:int = 0):
	chapter_restart(n)
	if Data.current_level:
		goto("chapter")
	action_finish("goto_chapter")

func goto_end(target:String):
	var end = Data.END.get(target)
	if end:
		goto(end)
	else:
		printerr("End '{0}' not exists".format(target))
	action_finish("goto_end")



func chapter_unlock(n:int):
	if Data.LEVEL.get(n):
		SaveData.add_unlock_chapter(n)
	action_finish("chapter_unlock")

func chapter_restart(n = null):
	if not n:
		var level = Data.current_level
		if level:
			level.init()
	else:
		Data.set_level(n)
	Effect.switch_opacity(false)
	var scene = get_chapter_scene()
	if scene:
		scene.next_card()
	action_finish("chapter_restart")



func set_text(text = ""):
	if not text is String:
		text = ""
	Dialog.set_text_only(text)
	Dialog.update_text_finished.connect(_on_scene_update_text_finished)
func _on_scene_update_text_finished():
	Dialog.update_text_finished.disconnect(_on_scene_update_text_finished)
	action_finish("set_text")

func set_text_color(color = null):
	if not color is Color:
		color = null
	Dialog.set_color(color)
	action_finish("set_text_color")

func set_text_outline_color(color = null):
	if not color is Color:
		color = null
	Dialog.set_outline_color(color)
	action_finish("set_text_outline_color")

func set_text_char_color(key:String):
	Dialog.set_char_color(key)
	action_finish("set_text_char_color")

func set_text_size(size = null):
	if not size is int:
		size = null
	Dialog.set_text_size(size)
	action_finish("set_text_size")

func set_text_default(_arg):
	Dialog.set_default()
	action_finish("set_text_default")



func set_backgorund(target:String):
	var image_path = Data.BACKGORUND.get(target)
	if image_path and ResourceLoader.exists(image_path):
		var background_node = get_tree().current_scene.get_node("%background")
		if background_node:
			background_node = load(image_path)
	action_finish("set_backgorund")

func start_effect(target:String):
	Effect.call(target)
	Effect.anim_finished.connect(_on_effect_anim_finished)
func _on_effect_anim_finished(_anim_name):
	Effect.anim_finished.disconnect(_on_effect_anim_finished)
	action_finish("start_effect")
	



func next_card():
	var scene = get_chapter_scene()
	if scene:
		scene.next_card()

func insert_card(target:String):
	Data.current_level.insert_card(target)
	action_finish("insert_card")


func show_card(is_show:bool = true):
	var scene:ChapterScene = get_chapter_scene()
	if scene:
		if is_show:
			scene.show_card()
		else:
			scene.hide_card()
		scene.show_card_finished.connect(_on_show_card_finished)
func _on_show_card_finished():
	var scene:ChapterScene = get_chapter_scene()
	if scene:
		scene.show_card_finished.disconnect(_on_show_card_finished)
	action_finish("show_card")
	


func exist_item(target):
	var result = target in Data.item
	action_finish("exist_item_{0}".format([result]))
	return result

func add_item(target):
	if not exist_item(target):
		Data.item.append(target)
	action_finish("add_item")

func remove_item(target):
	if exist_item(target):
		Data.item.erase(target)
	action_finish("remove_item")



func sleep(time:float):
	sleep_timer = time

func console(s):
	print(s)
	action_finish("console")
