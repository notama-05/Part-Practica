extends Node2D

@onready var MusicS = $VBoxContainer/MusicS
@onready var EffectsS = $VBoxContainer/EffectsS

func _ready():
	MusicS.value = Global.MusicVolume
	EffectsS.value = Global.EffectsVolume

func _on_accept_b_pressed():
	Global.MusicVolume = MusicS.value
	Global.EffectsVolume = EffectsS.value
	Global.save_data()
	get_tree().change_scene_to_file("res://Assets/Scenes/init_menu.tscn")
