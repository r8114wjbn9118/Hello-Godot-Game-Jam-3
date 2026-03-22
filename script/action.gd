extends Node

signal action_finished

var sleep_timer:float = 0.0

func get_chapter_scene():
	var scene = get_tree().current_scene
	return scene if scene is ChapterScene else null

func _process(delta: float) -> void:
	if sleep_timer > 0.0:
		sleep_timer = max(sleep_timer - delta, 0.0)
		if sleep_timer == 0.0:
			action_finished.emit("sleep")


func goto(target:String):
	var scene = Data.SCENE.get(target)
	if scene:
		get_tree().change_scene_to_file(scene)
	else:
		printerr("Scene '{0}' not exists".format(target))
	action_finished.emit("goto")

func goto_chapter(n:int = 0):
	chapter_restart(n)
	if Data.current_level:
		goto("chapter")
	action_finished.emit("goto_chapter")

func goto_end(target:String):
	var end = Data.END.get(target)
	if end:
		goto(end)
	else:
		printerr("End '{0}' not exists".format(target))
	action_finished.emit("goto_end")



func chapter_unlock(n:int):
	if Data.LEVEL.get(n):
		SaveData.add_unlock_chapter(n)
	action_finished.emit("chapter_unlock")

func chapter_restart(n:int = 0):
	Data.set_level(n)
	action_finished.emit("chapter_restart")



func set_text(text:String):
	var scene = get_chapter_scene()
	if scene:
		scene.set_text(text)
		scene.update_text_finished.connect(_on_scene_update_text_finished)
func _on_scene_update_text_finished(scene:ChapterScene):
	scene.update_text_finished.disconnect(_on_scene_update_text_finished)
	action_finished.emit("set_text")

func set_backgorund(target:String):
	var image_path = Data.BACKGORUND.get(target)
	if image_path and ResourceLoader.exists(image_path):
		var background_node = get_tree().current_scene.get_node("%background")
		if background_node:
			background_node = load(image_path)
	action_finished.emit("set_backgorund")

func start_effect(target:String):
	Effect.call(target)
	Effect.anim_finished.connect(_on_effect_anim_finished)
func _on_effect_anim_finished(_anim_name):
	Effect.anim_finished.disconnect(_on_effect_anim_finished)
	action_finished.emit("start_effect")
	



func next_card():
	var scene = get_chapter_scene()
	if scene:
		scene.next_card()

func insert_card(target:String):
	Data.current_level.insert_card(target)
	action_finished.emit("insert_card")


func show_card(is_hide:bool = false):
	var scene = get_chapter_scene()
	if scene:
		if is_hide:
			scene.hide_card()
		else:
			scene.show_card()
	


func exist_item(target):
	var result = target in Data.item
	action_finished.emit(exist_item, result)
	return result

func add_item(target):
	if not exist_item(target):
		Data.item.append(target)
	action_finished.emit("add_item")

func remove_item(target):
	if exist_item(target):
		Data.item.erase(target)
	action_finished.emit("remove_item")



func sleep(time:float):
	sleep_timer = time

func console(s):
	print(s)
	action_finished.emit("console")
