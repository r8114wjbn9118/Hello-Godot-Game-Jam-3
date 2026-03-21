extends Node

var unlock_chapter = {}

func add_unlock_chapter(n):
	if unlock_chapter.get(n) == true:
		return false
	
	unlock_chapter.set(n, true)
	return true
