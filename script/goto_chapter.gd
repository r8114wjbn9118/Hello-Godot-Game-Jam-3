extends Button

@export var level:int

func _ready() -> void:
	pressed.connect(_on_pressed)
	
	if not level in SaveData.unlock_chapter.keys():
		var label = get_node("Label")
		if label:
			label.visible = false
		
		modulate = Color.BLACK
		disabled = true


func _on_pressed():
	Action.goto_chapter(level)
