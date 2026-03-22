class_name Level
extends Resource

@export var background:Texture2D
@export var card_deck:Array[CardData]

var level_number = null

var card_list = []
var used_card = []

var item = []

func init(n):
	level_number = n
	
	card_list = card_deck.duplicate_deep();
	card_list.reverse()
	
	used_card.clear()
	item.clear()

func get_next_card():
	var card = card_list.pop_back()
	print(card, card_list)
	if card:
		used_card.append(card)
	return card

func insert_card(target:String, level:int = level_number):
	var card_data_path = "{0}/{1}/{2}.tres".format([
		Data.CARD_DATA_DIR, level, target
	])
	if ResourceLoader.exists(card_data_path):
		var card_data:CardData = load(card_data_path)
		if card_data:
			card_list.append(card_data)

func back_last_card():
	var card = used_card.get(len(used_card) - 2)
	if card:
		card_list.append(card)
