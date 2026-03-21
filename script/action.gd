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
	var level = Data.LEVEL.get(n)
	if level:
		Data.set_level(level)
		return true
	else:
		printerr("Level {0} not exists".format(n))
		return false



func set_text(text:String):
	pass

func set_backgorund(target:String):
	pass

func start_effect(target:String):
	pass



func insert_card(target:String):
	pass



func add_item(target):
	pass

func remove_item(target):
	pass

func console(s):
	print(s)
