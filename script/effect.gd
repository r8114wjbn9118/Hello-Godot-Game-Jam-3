extends Node2D

signal anim_finished

func chapter_2_B_end():
	%AnimationPlayer.play("chapter_2_B_end")
	
func chapter_3_A_dead():
	%AnimationPlayer.play("chapter_3_A_dead")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_finished.emit(anim_name)
