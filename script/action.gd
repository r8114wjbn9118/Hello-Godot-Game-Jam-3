extends Node

func goto(target:String):
	var scene = Data.SCENE.get(target)
	if scene:
		get_tree().change_scene_to_file(scene)
	else:
		printerr("Scene '{0}' not exists".format(target))

func goto_chapter(n:int = 0):
	var result = chapter_restart(n)
	if result:
		goto("chapter")

func goto_end(target:String):
	var end = Data.END.get(target)
	if end:
		goto(end)
	else:
		printerr("End '{0}' not exists".format(target))



func chapter_unlock(n:int):
	if Data.LEVEL.get(n):
		return SaveData.add_unlock_chapter(n)
	return false

func chapter_restart(n:int = 0):
	return Data.set_level(n)



func set_text(text:String):
	pass

func set_backgorund(target:String):
	var image_path = Data.BACKGORUND.get(target)
	if image_path and ResourceLoader.exists(image_path):
		var background_node = get_tree().current_scene.get_node("%background")
		if background_node:
			background_node = load(image_path)
		

func start_effect(target:String):
	Effect.call(target)



func insert_card(target:String):
	Data.current_level.insert_card(target)

func back_last_card(_t):
	Data.current_level.back_last_card()



func exist_item(target):
	return target in Data.item

func add_item(target):
	if not exist_item(target):
		Data.item.append(target)
		return true
	return false

func remove_item(target):
	if exist_item(target):
		Data.item.erase(target)



func console(s):
	print(s)
