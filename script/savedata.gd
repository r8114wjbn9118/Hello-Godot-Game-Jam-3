extends Node

var path = "user://data.res"

const key = "596F55466F556E4454684550615373576F526421"

var repo:ConfigFile = null

var unlock_chapter = {}

func _ready() -> void:
	repo = ConfigFile.new()
	load_file()


func add_unlock_chapter(n):
	if unlock_chapter.get(n) == true:
		return false
	
	unlock_chapter.set(n, true)
	save_file()
	return true

func get_data():
	return unlock_chapter

func set_data(_data):
	unlock_chapter = _data






func save_resource(data):
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, key)
	if file:
		return file.store_var(data)
	return false

func load_resource():
	var file = FileAccess.open_encrypted_with_pass(path, FileAccess.READ, key)
	if file:
		return file.get_var()
	return null

func save_file():
	var data = get_data()
	return save_resource(data)

func load_file():
	var data = load_resource()
	if data:
		set_data(data)
		return data
	return null
