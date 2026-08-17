extends Node2D



func _on_play_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")


func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/tutorial.tscn")

func _on_configuration_pressed():
	#get_tree().change_scene_to_file("res://Assets/Scenes/configuration.tscn")
	pass 
