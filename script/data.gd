extends Node

var CARD = preload("uid://cev16g6q6uawh")
var CARD_DATA_DIR = "res://card/data"

var SCENE = {
	"title": "uid://ckymik3t54our",
	"chapter": "uid://b8tvwo6als4vk",
}

var LEVEL = [null,
	"uid://cfy8vvcqdcn5j",
	"uid://citga58l7qqst",
	"uid://ckrulvso1rtjr",
	"uid://by0l0m3cai0wb",
]

var END = {
	
}

var BACKGORUND = {
	"date": "uid://bwjmaub57wbdx",
	"nightroom": "uid://cysobaspo75as",
	"room": "uid://cdeymj65o2htv",
}

var current_level:Level = null
var card_action:String = ""
var item = []

func set_level(n):
	var level = LEVEL.get(n)
	if level:
		level = load(level)
		if level:
			current_level = level
			current_level.init(n)
		return true
	else:
		printerr("Level {0} not exists".format(n))
		return false

func set_card_action(d:String = ""):
	card_action = d
