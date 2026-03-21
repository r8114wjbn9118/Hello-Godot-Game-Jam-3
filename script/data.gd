extends Node

var CARD = preload("uid://cev16g6q6uawh")

var SCENE = {
	"title": "uid://ckymik3t54our",
	"chapter": "uid://b8tvwo6als4vk",
}

var LEVEL = [null,
	"uid://cfy8vvcqdcn5j"
]

var END = {
	
}

var BACKGORUND = {
	"date": "uid://bwjmaub57wbdx",
	"nightroom": "uid://cysobaspo75as",
	"room": "uid://cdeymj65o2htv",
}

var EFFECT = {}

var current_level:Level = null
var card_action:int = 0
var item = []

func set_level(level:Level):
	current_level = level
	card_action = 0
	item.clear()

func set_card_action(n:int):
	card_action = n
