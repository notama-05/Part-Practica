extends Node2D

@onready var sierra = preload("res://Assets/Scenes/sierra.tscn")
@onready var paso1 = $CenterContainer
@onready var paso2 = $Container
@onready var song = $AudioStreamPlayer2D


func create_sierras():
	while get_tree().current_scene.name == "Init_menu":
		for marker in get_children():
			if marker is Marker2D:
				await get_tree().create_timer(0.05).timeout
				var newsierra = sierra.instantiate()
				get_parent().add_child.call_deferred(newsierra)
				newsierra.global_position = marker.global_position
		await get_tree().create_timer(0.4).timeout

func _ready():
	if Global.MusicVolume != 0:
		song.volume_db = lerp(-15.0, 10.0, (Global.MusicVolume/100.0))
	else:
		song.stop()
	create_sierras()

func _process(delta):
	if Global.paso == 1:
		paso1.visible = true
		paso2.visible = false
	if Input.is_action_pressed("click"):
		Global.paso = 2
		paso1.visible = false
		paso2.visible = true

func _on_area_2d_area_entered(area):
	area.queue_free()	

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/main.tscn")

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/tutorial.tscn")

func _on_configuration_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/configuration.tscn")

func _on_personalization_pressed():
	get_tree().change_scene_to_file("res://Assets/Scenes/personalization.tscn")
