extends Node2D

signal anim_finished

func switch_opacity(is_show = null):
	if is_show == null:
		visible = !visible
	else:
		visible = !!is_show
		
func show_black():
	%AnimationPlayer.play("black")

func chapter_2_B_end():
	%AnimationPlayer.play("chapter_2_B_end")
	
func chapter_3_A_dead():
	%AnimationPlayer.play("chapter_3_A_dead")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	anim_finished.emit(anim_name)
